import asyncio

from event import APEvent

class APProxy:
    def __init__(self, hs_to_ap_proxy_file_path: str, ap_to_hs_proxy_file_path: str):
        self.hs_to_ap_proxy_file_path = hs_to_ap_proxy_file_path
        self.ap_to_hs_proxy_file_path = ap_to_hs_proxy_file_path
        self.listen_tasks = set()
        self.event_queue = asyncio.Queue()

    async def listen_hs_to_ap(self):
        # Listen for events from HS -> AP file and process them
        while True:
            with open(self.hs_to_ap_proxy_file_path, 'r+') as f:
                for line in f.readlines():
                    event = APEvent.deserialize(line.strip())
                    print(event)
                f.seek(0)
                f.truncate(0)

            await asyncio.sleep(1)

    async def listen_ap_to_hs(self):
        # Listen for events from AP -> HS file and process them
        pass
    

    def start(self):
        self.listen_tasks.add(asyncio.create_task(self.listen_hs_to_ap()))
        self.listen_tasks.add(asyncio.create_task(self.listen_ap_to_hs()))
    
    def stop(self):
        for task in self.listen_tasks:
            task.cancel()