from dataclasses import dataclass


@dataclass
class APEvent:
    event_type: str
    data: str

    @classmethod
    def serialize(cls, event_type: str, data: str) -> str:
        return f"{event_type}:{data}"
    
    @staticmethod
    def deserialize(cls, payload: str) -> 'APEvent':
        event_type, data = payload.split(":", 1)
        return cls(event_type, data)