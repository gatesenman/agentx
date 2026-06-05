---
name: data-analysis
description: 数据分析工作流。当需要分析数据、生成报表或可视化时使用。
---

# 数据分析工作流

## 步骤

### 1. 理解需求
```
确认:
  □ 要分析什么数据?
  □ 数据在哪里? (数据库/文件/API)
  □ 要回答什么问题?
  □ 输出格式? (报表/图表/SQL/代码)
```

### 2. 连接数据源
```bash
# 数据库连接
psql -h host -U user -d dbname
# 或
mysql -h host -u user -p dbname

# 文件数据
cat data.csv | head -20
python -c "import pandas as pd; print(pd.read_csv('data.csv').head())"

# API 数据
curl -s https://api.example.com/data | python -m json.tool | head -50
```

### 3. 探索数据
```sql
-- 表结构
\d table_name                    -- PostgreSQL
DESCRIBE table_name;             -- MySQL

-- 行数和分布
SELECT COUNT(*) FROM table_name;
SELECT column, COUNT(*) FROM table_name GROUP BY column ORDER BY 2 DESC LIMIT 20;

-- 时间范围
SELECT MIN(created_at), MAX(created_at) FROM table_name;

-- 数据质量
SELECT COUNT(*) FILTER (WHERE column IS NULL) FROM table_name;
```

### 4. 分析
```sql
-- 聚合分析
SELECT
    date_trunc('day', created_at) AS day,
    COUNT(*) AS count,
    AVG(value) AS avg_value
FROM table_name
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY 1
ORDER BY 1;

-- 分布分析
SELECT
    CASE
        WHEN value < 10 THEN '0-9'
        WHEN value < 100 THEN '10-99'
        ELSE '100+'
    END AS bucket,
    COUNT(*) AS count
FROM table_name
GROUP BY 1
ORDER BY 1;

-- 趋势分析
SELECT
    date_trunc('week', created_at) AS week,
    COUNT(*) AS total,
    COUNT(*) FILTER (WHERE status = 'success') AS success,
    ROUND(100.0 * COUNT(*) FILTER (WHERE status = 'success') / COUNT(*), 1) AS success_rate
FROM table_name
GROUP BY 1
ORDER BY 1;
```

### 5. 可视化
```python
import matplotlib.pyplot as plt
import pandas as pd

# 读取数据
df = pd.read_csv('data.csv')

# 折线图
plt.figure(figsize=(12, 6))
plt.plot(df['date'], df['value'])
plt.title('趋势图')
plt.xlabel('日期')
plt.ylabel('值')
plt.savefig('chart.png', dpi=150, bbox_inches='tight')

# 柱状图
df.groupby('category')['count'].sum().plot(kind='bar')
plt.savefig('bar.png', dpi=150, bbox_inches='tight')
```

### 6. 报告
```
message_user:
  - 关键发现 (3-5 条)
  - 数据支撑 (数字/百分比)
  - 图表附件
  - 建议操作 (如适用)
```

## 原则
- 先探索再分析（理解数据结构和质量）
- 大数据集用 LIMIT（先采样验证查询）
- SQL 优先于全量加载（在数据库层聚合）
- 验证结果合理性（总数、百分比、趋势）
- 不暴露敏感数据（脱敏/聚合）
