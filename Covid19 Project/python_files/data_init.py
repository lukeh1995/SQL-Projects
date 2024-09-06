import pandas as pd

# Load the CSV file
df = pd.read_csv(r"C:\Users\60234651\SQL-Projects\Covid19 Project\coviddata.csv")

# Display the first few rows of the DataFrame
print(df.head())

# Convert all column names to lowercase
df.columns = df.columns.str.lower()

# Display the first few rows to verify the changes
print(df.head())

# Print the column names
print(df.columns.tolist())

# Generate patient id column
df['patient_id'] = range(1, len(df) + 1)
# Create Patients DataFrame
patients_df = df[['patient_id', 'sex', 'age', 'clasiffication_final', 'patient_type', 'date_died']]

# Create Health Conditions DataFrame
health_conditions_df = df[['patient_id', 'pneumonia', 'pregnant', 'diabetes', 
                            'copd', 'asthma', 'inmsupr', 'hipertension', 
                            'other_disease', 'cardiovascular', 'obesity', 
                            'renal_chronic', 'tobacco']]

# Create Treatment Details DataFrame
treatment_details_df = df[['patient_id', 'usmer', 'medical_unit', 'intubed', 'icu']]


# Use .loc to avoid SettingWithCopyWarning and replace values safely
for col in treatment_details_df.columns:
    treatment_details_df.loc[:, col] = treatment_details_df[col].replace({1: True, 2: False, 97: None, 99: None})

# Convert the boolean columns correctly
for col in treatment_details_df.columns:
    if col not in ['patient_id', 'medical_unit']:  # Ensure we don't convert non-boolean columns
        treatment_details_df[col] = treatment_details_df[col].astype('boolean')

# Handle invalid date values in patients_df
patients_df.loc[:, 'date_died'] = patients_df['date_died'].replace('9999-99-99', None)

# Convert 'date_died' to object type to prevent errors
patients_df['date_died'] = patients_df['date_died'].astype('object')


# Display the DataFrames to verify
print("Patients DataFrame:")
print(patients_df.head())

print("\nHealth Conditions DataFrame:")
print(health_conditions_df.head())

print("\nTreatment Details DataFrame:")
print(treatment_details_df.head())

from sqlalchemy import create_engine, text

# Create a database connection
engine = create_engine('postgresql://postgres:ZrKh2nZS!@localhost/covid_patient_data')


# Drop dependent tables first, handling possible errors
with engine.connect() as connection:
    try:
        connection.execute(text("DROP TABLE IF EXISTS health_conditions CASCADE;"))
        connection.execute(text("DROP TABLE IF EXISTS treatment_details CASCADE;"))
        connection.execute(text("DROP TABLE IF EXISTS patients;"))
        print("Tables dropped successfully.")
    except Exception as e:
        print("Error dropping tables:", e)

# Create tables again after dropping
with engine.connect() as connection:
    try:
        connection.execute(text("""
        CREATE TABLE patients (
            patient_id SERIAL PRIMARY KEY,
            sex INTEGER CHECK (sex IN (1, 2)),
            age INTEGER,
            classification_final INTEGER CHECK (classification_final IN (1, 2, 3, 4)),
            patient_type INTEGER CHECK (patient_type IN (1, 2)),
            date_died DATE
        );
        """))

        connection.execute(text("""
        CREATE TABLE health_conditions (
            condition_id SERIAL PRIMARY KEY,
            patient_id INTEGER REFERENCES patients(patient_id) ON DELETE CASCADE,
            pneumonia BOOLEAN,
            pregnant BOOLEAN,
            diabetes BOOLEAN,
            copd BOOLEAN,
            asthma BOOLEAN,
            inmsupr BOOLEAN,
            hipertension BOOLEAN,
            other_disease BOOLEAN,
            cardiovascular BOOLEAN,
            obesity BOOLEAN,
            renal_chronic BOOLEAN,
            tobacco BOOLEAN
        );
        """))

        connection.execute(text("""
        CREATE TABLE treatment_details (
            treatment_id SERIAL PRIMARY KEY,
            patient_id INTEGER REFERENCES patients(patient_id) ON DELETE CASCADE,
            usmer BOOLEAN,
            medical_unit VARCHAR(100),
            intubed BOOLEAN,
            icu BOOLEAN
        );
        """))
        print("Tables created successfully.")
    except Exception as e:
        print("Error creating tables:", e)

# Load DataFrames into PostgreSQL tables
patients_df.to_sql('patients', engine, if_exists='append', index=False)
health_conditions_df.to_sql('health_conditions', engine, if_exists='append', index=False)
treatment_details_df.to_sql('treatment_details', engine, if_exists='append', index=False)

print("Data loaded successfully into PostgreSQL.")