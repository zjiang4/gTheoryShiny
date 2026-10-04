### 快速开始 / Quick Start

这个工具把概化理论分析分成三个连续步骤。第一次使用时，建议先保留默认的示例数据。

1. **Data Input**：选择示例数据或上传 CSV。长数据应做到“一行代表一次评分”；宽数据可先转换成长数据。
2. **Data Structure**：指定人员/对象 ID、数值结果变量和误差来源（facets，例如题目、评分者、任务或测次）。
3. **Data Analysis**：先运行 G-study，再用 D-study 比较不同测量设计的可靠性。

点击每一步的 **Confirm** 后，应用会自动进入下一页。

### 核心概念 / Core Concepts

- **ID / measurement object**：最终要区分或评价的对象，例如学生、患者或作品。
- **Outcome**：数值型评分结果。
- **Facet**：可能带来测量误差的条件，例如题目、评分者、任务、场合或测次。
- **G-study**：把总变异拆分到人员、facet、交互作用和残差，帮助定位主要误差来源。
- **D-study**：根据 G-study 的方差分量，估计增加或减少题目、评分者等条件后，可靠性会怎样变化。

### 如何解释系数 / Interpreting Coefficients

- **Generalizability coefficient (G coefficient)** 用于相对决策，例如比较学生之间的排序。
- **Dependability coefficient (Phi)** 用于绝对决策，例如判断是否达到固定合格线。
- 系数越接近 1，测量越稳定。0.70、0.80、0.90 只能作为经验参考；实际要求取决于决策风险、研究用途和领域规范。
- 如果页面提示 **singular fit**、收敛警告或不可估计的随机项，应先检查数据结构和重复测量是否充分，再解释结果。

### 数据准备检查 / Data Checklist

- ID、Outcome 和 Facet 必须是不同变量。
- Outcome 必须可转换为数值。
- 每个 facet 至少需要两个水平。
- 随机效应需要重复观测；如果某个组合每行只出现一次，应用会自动省略该不可估计项并给出提示。
- Logit 只适用于 0/1 结果；Poisson 只适用于非负整数；Inverse Gamma 要求结果严格大于 0。
- 上传文件最大为 50 MB。列名会自动转换为唯一、合法的 R 变量名。

### 内置示例 / Examples

1. **Rajaratnam.2**：`Person` 为 ID，`Score` 为 Outcome，默认 facets 为 `Subtest` 和 `Item`。
2. **Brennan.3.2**：`Person` 为 ID，`Score` 为 Outcome，默认 facets 为 `Task` 和 `Rater`。

### AI Assistant

AI 助手可以用通俗语言解释 G-study/D-study、指出主要误差来源，并根据 D-study 提供设计调整建议。

为保护隐私，应用默认只发送变量名、样本量、公式和汇总结果，**不会发送原始作答行或人员记录**。AI 输出是解释和决策支持，不能替代研究者对设计、模型假设和领域标准的判断。

### 高级功能 / Advanced Features

- Bootstrap confidence intervals：通过参数 bootstrap 评估方差分量和 D-study 结果的不确定性。
- Covariates：把选定变量作为固定效应加入模型。
- Multivariate G-theory：当前标记为实验功能，使用前应检查固定 facet 权重、协方差结构和模型诊断。
- Downloads：可下载转换后的数据、人员随机效应、G-study bootstrap 结果和 D-study 方差表。

### 2026-10-03 更新

本版本增加了输入校验、不可估计随机项过滤、模型诊断、初学者结果解释、会话隔离、安全公式解析、Windows 并行 bootstrap 支持，以及隐私保护的 NVIDIA API AI 助手。
