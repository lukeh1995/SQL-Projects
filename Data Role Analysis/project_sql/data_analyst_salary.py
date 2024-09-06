import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib.ticker as ticker

# Load the data
df = pd.read_csv(r"C:\Users\60234651\SQL-Projects\Data Role Analysis\project_sql\salary_insights.csv")

# Display the first few rows of the DataFrame
print(df.head())

# Get a summary of the DataFrame
print(df.info())

# Display descriptive statistics
print(df.describe())

print(df.isnull().sum())

# Drop rows with missing salary or skills if necessary
df.dropna(subset=['salary', 'skills'], inplace=True)

# Remove duplicates if any
df.drop_duplicates(inplace=True)
import matplotlib.ticker as ticker

# Salary Distribution Analysis
plt.figure(figsize=(10, 6))
sns.histplot(df['salary'], bins=20, kde=True)

# Calculate mean and median
mean_salary = df['salary'].mean()
median_salary = df['salary'].median()

# Add vertical lines for mean and median
plt.axvline(mean_salary, color='red', linestyle='--', label='Mean Salary')
plt.axvline(median_salary, color='blue', linestyle='--', label='Median Salary')

# Format y-axis as currency
formatter = ticker.StrMethodFormatter('${x:,.0f}')
plt.gca().yaxis.set_major_formatter(formatter)

plt.title('Salary Distribution for Data Analyst Positions')
plt.xlabel('Salary')
plt.ylabel('Frequency')
plt.legend()
plt.show()

# Split the skills into a list (assuming skills are separated by commas)
skills_series = df['skills'].str.split(',', expand=True).stack()

# Create a DataFrame of skills
skills_df = skills_series.reset_index(drop=True)

# Count the frequency of each skill
skills_count = skills_df.value_counts()

# Display the top 10 skills
print(skills_count.head(10))

# Visualize the top 10 skills
plt.figure(figsize=(12, 6))
sns.barplot(x=skills_count.head(10).index, y=skills_count.head(10).values)
plt.title('Top 10 Skills for Data Analyst Positions')
plt.xlabel('Skills')
plt.ylabel('Frequency')
plt.xticks(rotation=45)
plt.show()

# Create a new DataFrame for analysis
salary_skills_df = df[['salary', 'skills']].copy()

# Count unique skills and their corresponding salaries
salary_skills_df['skill_count'] = salary_skills_df['skills'].str.split(',').apply(len)

# Visualize the relationship
plt.figure(figsize=(10, 6))
sns.boxplot(x='skill_count', y='salary', data=salary_skills_df)
plt.title('Salary vs. Number of Skills')
plt.xlabel('Number of Skills')
plt.ylabel('Salary')
plt.show()

# Group by company and calculate the average salary
company_salary = df.groupby('company')['salary'].mean().sort_values(ascending=False)

# Display the top 10 companies
print(company_salary.head(10))

# Visualize the top 10 companies
plt.figure(figsize=(12, 6))
company_salary.head(10).plot(kind='bar')
plt.title('Top 10 Companies by Average Salary for Data Analysts')
plt.xlabel('Company')
plt.ylabel('Average Salary')
plt.xticks(rotation=45)
plt.show()