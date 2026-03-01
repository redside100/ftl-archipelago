from pathlib import Path
from xml.etree import ElementTree as ET
from xml.dom import minidom

TARGET_TAGS = {"event", "destroyed", "deadCrew", "surrender", "gotaway"}

REWARD_TAGS = {
    "autoReward",
    "item_modify",
    "drone",
    "weapon",
    "augment",
    "crewMember",
}


def create_remove_item_nodes(node: ET.Element) -> ET.Element | None:

    item_specs = []
    for item_modify_node in node.findall("item_modify"):
        for item_node in item_modify_node.findall("item"):
            if (
                int(item_node.attrib.get("min", "0")) > 0
                and int(item_node.attrib.get("max", "0")) > 0
            ):
                item_specs.append(
                    (
                        item_node.attrib["type"],
                        item_node.attrib["min"],
                        item_node.attrib["max"],
                    )
                )

    if not item_specs:
        return None

    remove_node = ET.Element("mod:findLike", {"type": "item_modify"})
    for item_spec in item_specs:
        remove_item_node = ET.Element("mod:findLike", {"type": "item"})
        remove_item_node.append(
            ET.Element(
                "mod:selector",
                {"type": item_spec[0], "min": item_spec[1], "max": item_spec[2]},
            )
        )
        remove_item_node.append(ET.Element("mod:removeTag"))
        remove_node.append(remove_item_node)

    return remove_node


def does_set_ship_neutral(node: ET.Element):
    ship_node = node.find("ship")
    if ship_node is None:
        return False
    return ship_node.attrib.get("hostile") == "false"


def has_reward_tags(node: ET.Element):
    for tag in REWARD_TAGS - {"item_modify"}:
        if node.findall(tag):
            return True

    # Check if item_modify with positive item modifiers
    if create_remove_item_nodes(node) is not None:
        return True

    return False


def get_all_paths(tree: ET.ElementTree) -> list[tuple[list, ET.Element]]:
    paths = []

    # Build a parent map: child -> parent
    parent_map = {c: p for p in tree.iter() for c in p}

    def build_path(node: ET.Element):
        path_parts = []
        current = node
        while current is not None:
            parent = parent_map.get(current)
            if parent is not None:
                # find index among siblings with same tag
                siblings = [c for c in list(parent) if c.tag == current.tag]
                if len(siblings) == 1:
                    path_parts.append(
                        {
                            "tag": current.tag,
                            "index": 0,
                            "name": current.attrib.get("name"),
                        }
                    )
                else:
                    index = siblings.index(current)
                    path_parts.append(
                        {
                            "tag": current.tag,
                            "index": index,
                            "name": current.attrib.get("name"),
                        }
                    )
            else:
                path_parts.append({"tag": current.tag, "index": None})  # root node
            current = parent

        return list(reversed(path_parts))

    # Walk the tree and check tags
    for node in tree.iter():
        if node.tag in TARGET_TAGS and has_reward_tags(node):
            paths.append((build_path(node), node))

    return paths


def create_remove_node(tag: str):
    node = ET.Element("mod:findLike", {"type": tag})
    node.append(ET.Element("mod:removeTag"))
    return node


def create_remove_ship_neutral_node():
    node = ET.Element("mod:findLike", {"type": "ship"})
    node.append(ET.Element("mod:selector", {"hostile": "false"}))
    node.append(ET.Element("mod:removeTag"))
    return node


def create_choice_node():
    node = ET.Element("mod-append:choice")
    text = ET.Element("text")
    text.text = "[FTL Archipelago] End event (complete check)"
    node.append(text)
    node.append(ET.Element("event", {"load": "AP_REWARD"}))
    return node


def generate_xml_append(xml_path: Path):
    tree = ET.parse(xml_path.as_posix())
    # get all possible reward tag paths
    node_paths = get_all_paths(tree)

    append_nodes = []
    for node_path, node in node_paths:
        # Create a modFind patch for each
        root_node = None
        current_node = None
        # Get to the leaf
        for segment in node_path:
            if segment["tag"] == "FTL":
                continue

            attributes = {"type": segment["tag"]}

            if segment["name"] is not None:
                attributes["name"] = segment["name"]
                new_node = ET.Element("mod:findName", attributes)
            else:
                if segment["index"] is not None:
                    attributes["start"] = str(segment["index"])
                    attributes["limit"] = "1"

                new_node = ET.Element("mod:findLike", attributes)

            if current_node is not None:
                current_node.append(new_node)

            if root_node is None:
                root_node = new_node

            current_node = new_node

        # Remove reward tags, add choice to trigger custom event
        for reward_tag in REWARD_TAGS - {"item_modify"}:
            current_node.append(create_remove_node(reward_tag))

        # Remove all positive item modifiers
        remove_item_nodes = create_remove_item_nodes(node)
        if remove_item_nodes is not None:
            current_node.append(remove_item_nodes)

        # no mercy
        if does_set_ship_neutral(node):
            current_node.append(create_remove_ship_neutral_node())

        current_node.append(create_choice_node())
        append_nodes.append(root_node)

    if append_nodes:
        Path("dist/data/").mkdir(exist_ok=True)
        Path(f"dist/data/{xml_path.name}.append").write_text(
            "\n\n".join(
                [ET.tostring(node, encoding="unicode") for node in append_nodes]
            )
        )


def main():
    data_folder = Path("ftl_data/data/")
    for xml_file in data_folder.glob("**/*.xml"):
        generate_xml_append(xml_file)


if __name__ == "__main__":
    main()
