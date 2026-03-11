# Mermaid Diagram Templates for Live Preview

## Flowchart
```mermaid
flowchart TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Process]
    B -->|No| D[End]
    C --> D
```

## Sequence Diagram
```mermaid
sequenceDiagram
    participant Alice
    participant Bob
    Alice->>Bob: Hello Bob, how are you?
    Bob-->>Alice: Great! And you?
    Alice->>Bob: Wonderful!
```

## Gantt Chart
```mermaid
gantt
    title Project Timeline
    section Development
    Phase 1 :a1, 2024-01-01, 30d
    Phase 2 :a2, after a1, 20d
    section Testing
    QA :b1, after a1, 15d
```

## State Diagram
```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Processing: Start
    Processing --> Complete: Done
    Complete --> [*]
```

## Class Diagram
```mermaid
classDiagram
    class Animal {
        -String name
        -int age
        +eat()
        +sleep()
    }
    class Dog {
        +bark()
    }
    Animal <|-- Dog
```

## Pie Chart
```mermaid
pie title Browser Market Share
    "Chrome" : 65
    "Firefox" : 15
    "Safari" : 15
    "Edge" : 5
```

## Git Graph
```mermaid
gitGraph
    commit id: "Initial commit"
    branch develop
    commit id: "Add feature"
    checkout main
    commit id: "v1.0 release"
    merge develop
```

## Entity Relationship Diagram
```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    LINE-ITEM {
        int item_id
        int qty
    }
```
