CREATE DATABASE IF NOT EXISTS devops_exam;
USE devops_exam;

CREATE TABLE IF NOT EXISTS results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    gender VARCHAR(50),
    email VARCHAR(255),
    score INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SHOW TABLES;


#kubectl logs -n devopsexamapp flask-app-cc876df7f-qrzks --- Table 'devops_exam.results' doesn't exist

#used to check the issue if any issue
