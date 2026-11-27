---
name: principle-sequence-verifiable-units
description: "适用于多步工作（批量扫改、迁移、一连串相似的编辑），以及你如何堆叠提交和 PR。把工作拆成每一步都以可验证状态结束的小单元，在做下一步之前检查上一步，并安排交付顺序，让这个顺序本身就向审阅者证明自己。"
disable-model-invocation: true
---

# Sequence work into verifiable units

Order work as small units that each end in a state you can check, and do not advance until the current one is green.

In a sweep, migration, or run of similar edits, each unit is a bracket: known-good state, one change, run the check, proceed. Run the per-unit check even when a tool does the edits.

Deliver in the order that proves the work: the failing test first, then the fix. The subtraction before the reshape. The baseline before the treatment. Each commit lands on its own.
