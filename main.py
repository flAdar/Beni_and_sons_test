import psycopg2
import pandas as pd
import numpy as np

# database and dwh configuration
hostname = 'localhost'
database = 'beni_and_sons'
dwh = 'data_warehous'
username = 'admin'
pwd = 'admin'
port_id = 5432


# extract data from beni_and_sons database into a dataframe objects
def extract():
    conn = None
    cur = None
    try:
        conn = psycopg2.connect(
            host=hostname,
            dbname=database,
            user=username,
            password=pwd,
            port=port_id
        )
        cur = conn.cursor()
        cur.execute("SELECT version();")
        record = cur.fetchone()
        print("You are connected to - ", database, record, "\n")
        fact_df = create_df(cur,
                            "select recruiter.id as recruiter_id, applicant.id as applicant_id, "
                            "recruiter.departmant_id "  
                            ", applicant.application_date, recruitment.recruitment_date, bonus.bonus_amount FROM "
                            "applicant FULL JOIN recruiter ON "  
                            "applicant.recruiter_id = recruiter.id FULL JOIN recruitment ON applicant.id = "
                            "recruitment.applicant_id LEFT JOIN "  
                            "bonus ON bonus.month = CAST((SPLIT_PART(recruitment.recruitment_date::TEXT, '-', "
                            "2))AS INTEGER) ")
        fact_df['bonus_amount'] = fact_df['bonus_amount'].replace(np.nan, 0)
        fact_df['recruitment_date'] = fact_df['recruitment_date'].astype(str)
        fact_df['application_date'] = fact_df['application_date'].astype(str)
        applicant_df = create_df(cur, "select id, city, birth_date, family_status FROM applicant")
        departmant_df = create_df(cur, "SELECT id, name FROM departmant")
        recruiter_df = create_df(cur, "SELECT id, city, birth_date, family_status, base_salary FROM recruiter")
        load(fact_df, applicant_df, departmant_df, recruiter_df)

    except Exception as error:
        print(error)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            conn.close()


def load(fact_df, applicant_df, departmant_df, recruiter_df):
    conn = None
    cur = None
    try:
        conn = psycopg2.connect(
            host=hostname,
            dbname=dwh,
            user=username,
            password=pwd,
            port=port_id
        )
        cur = conn.cursor()
        cur.execute("SELECT version();")
        record = cur.fetchone()
        print("You are connected to - ", dwh, record, "\n")

        for row, data in applicant_df.iterrows():
            [id, city, birth_date, family_status] = data.get(["id", "city", "birth_date", "family_status"])
            cur.execute(
                f"INSERT INTO dim_applicant (id, city, birth_date, family_status) VALUES ({id}, '{city}',"
                f"'{birth_date}','{family_status}') ON CONFLICT ON CONSTRAINT dim_applicant_pkey DO UPDATE SET"
                f"city='{city}', birth_date ='{birth_date}', family_status = '{family_status}'  ")
            print(cur.statusmessage)
            print(cur.query)
        conn.commit()

        for row, data in recruiter_df.iterrows():
            [id, city, birth_date, family_status, base_salary] = data.get(
                ["id", "city", "birth_date", "family_status", "base_salary"])
            cur.execute(
                f"INSERT INTO dim_recruiter (id, city, birth_date, family_status, base_salary) VALUES"
                f"({id}, '{city}', '{birth_date}', '{family_status}', {base_salary})"
                f"ON CONFLICT ON CONSTRAINT dim_recruiter_pkey DO UPDATE SET city='{city}',"
                f"birth_date ='{birth_date}', family_status = '{family_status}' , base_salary = {base_salary}")
            print(cur.statusmessage)
            print(cur.query)
        conn.commit()

        for row, data in departmant_df.iterrows():
            [id, name] = data.get(["id", "name"])
            cur.execute(
                f"INSERT INTO dim_departmant (id, name) VALUES ({id}, '{name}') ON CONFLICT ON CONSTRAINT "
                f"dim_departmant_pkey DO NOTHING")
            print(cur.statusmessage)
            print(cur.query)
        conn.commit()

        for row, data in fact_df.iterrows():
            print(data)
            cur.execute(
                f"INSERT INTO recruitment_process_fact (recruiter_id, applicant_id, department_id, application_date, "
                f"status, recruitment_date, bonus) VALUES ({data[0]}, {data[1]}, {data[2]}, '{data[3]}',"
                f"{False if data[4] == 'None' else True}, '{data[4]}',{data[5]}) ON CONFLICT ON CONSTRAINT "
                f"recruitment_process_fact_pkey DO UPDATE SET recruiter_id = {data[0]}, department_id={data[2]}, "
                f"application_date='{data[3]}', status={False if data[4] == 'None' else True}, recruitment_date='"
                f"{data[4]}', bonus={data[5]}")
            print(cur.statusmessage)
            print(cur.query)
        conn.commit()

    except Exception as error:
        print(error)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            conn.close()


def create_df(cur, query):
    cur.execute(query)
    data = cur.fetchall()
    cols = []
    for elt in cur.description:
        cols.append(elt[0])
    return pd.DataFrame(data=data, columns=cols)


extract()
