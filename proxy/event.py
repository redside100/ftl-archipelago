from dataclasses import dataclass


@dataclass
class APEvent:
    event_type: str
    data: str

    def serialize(event_type: str, data: str) -> str:
        return f"{event_type}:{data}"
    
    @classmethod
    def deserialize(cls, payload: str) -> 'APEvent':
        event_type, data = payload.split(":", 1)
        return cls(event_type, data)