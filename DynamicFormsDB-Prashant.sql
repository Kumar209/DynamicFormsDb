use test;

CREATE TABLE DynamicFormsRole (
    Id INT PRIMARY KEY IDENTITY(1,1),
    RoleName VARCHAR(50) NOT NULL UNIQUE,
    Description VARCHAR(200)
);




CREATE TABLE DynamicFormUser (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Email VARCHAR(150) UNIQUE NOT NULL,
    [Password] VARCHAR(255) NOT NULL,
    Active BIT CONSTRAINT DF_DynamicFormUser_Active DEFAULT(1),
    CreatedOn DATETIME CONSTRAINT DF_DynamicFormUser_CreatedOn DEFAULT(GETDATE()),
    ModifiedBy INT,
    ModifiedOn DATETIME,
    DeletedOn DATETIME,
    DeletedBy INT,
	RoleId INT,
    FOREIGN KEY (RoleId) REFERENCES DynamicFormsRole(Id)
);




CREATE TABLE SourceTemplate (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FormName VARCHAR(100) NOT NULL,
    [Description] VARCHAR(200),
    IsPublish BIT,
    [Version] INT,
    UserId INT,
    Active BIT CONSTRAINT DF_SourceTemplate_Active DEFAULT(1),
    CreatedOn DATETIME CONSTRAINT DF_SourceTemplate_CreatedOn DEFAULT(GETDATE()),
    CreatedBy INT,
    ModifiedBy INT,
    ModifiedOn DATETIME,
    DeletedOn DATETIME,
    DeletedBy INT,
    FOREIGN KEY (UserId) REFERENCES DynamicFormUser(Id)
);




CREATE TABLE TemplateSection (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FormId INT,
    SectionName VARCHAR(200) NOT NULL,
    [Description] VARCHAR(200),
    Active BIT CONSTRAINT DF_TemplateSection_Active DEFAULT(1),
    Slno INT,
    CreatedOn DATETIME,
    CreatedBy INT,
    ModifiedBy INT,
    ModifiedOn DATETIME,
    DeletedOn DATETIME,
    DeletedBy INT,
    FOREIGN KEY (FormId) REFERENCES SourceTemplate(Id)
);


CREATE TABLE FormQuestions (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Question VARCHAR(250) NOT NULL,
    Slno INT,
    Size VARCHAR(50),
    [Required] BIT,
	AnswerTypeId INT,
    DataType VARCHAR(50),
    [Constraint] VARCHAR(200),
    ConstraintValue VARCHAR(200),
    WarningMessage VARCHAR(200),
    Active BIT CONSTRAINT DF_FormQuestions_Active DEFAULT(1),
    CreatedOn DATETIME,
    CreatedBy INT,
    ModifiedBy INT,
    ModifiedOn DATETIME,
    DeletedOn DATETIME,
    DeletedBy INT,
	UserId INT,
	FOREIGN KEY (UserId) REFERENCES DynamicFormUser(Id)
);





CREATE TABLE AnswerType (
    Id INT PRIMARY KEY IDENTITY(1,1),
    TypeName VARCHAR(100) NOT NULL,
    Active BIT CONSTRAINT DF_AnswerType_Active DEFAULT(1),
    CreatedOn DATETIME,
    CreatedBy INT,
    ModifiedBy INT,
    ModifiedOn DATETIME,
    DeletedOn DATETIME,
    DeletedBy INT
);





CREATE TABLE AnswerOptions (
    Id INT PRIMARY KEY IDENTITY(1,1),
    AnswerTypeId INT,
    OptionValue VARCHAR(100),
    Active BIT CONSTRAINT DF_AnswerOptions_Active DEFAULT(1),
    CreatedOn DATETIME,
    CreatedBy INT,
    ModifiedBy INT,
    ModifiedOn DATETIME,
    DeletedOn DATETIME,
    DeletedBy INT,
    FOREIGN KEY (AnswerTypeId) REFERENCES AnswerType(Id)
);



CREATE TABLE AnswerMaster (
    Id INT PRIMARY KEY IDENTITY(1,1),
    QuestionId INT NOT NULL,
    AnswerOptionId INT NOT NULL,
    NextQuestionId INT,
	Active BIT CONSTRAINT DF_AnswerMaster_Active DEFAULT(1),
    FOREIGN KEY (QuestionId) REFERENCES FormQuestions(Id),
    FOREIGN KEY (AnswerOptionId) REFERENCES AnswerOptions(Id)
);


CREATE TABLE QuestionSectionMapping (
    Id INT PRIMARY KEY IDENTITY(1,1),
    QuestionId INT,
    SectionId INT,
	Active BIT CONSTRAINT DF_QuestionSectionMapping_Active DEFAULT(1),
    FOREIGN KEY (QuestionId) REFERENCES FormQuestions(Id),
    FOREIGN KEY (SectionId) REFERENCES TemplateSection(Id)
);



CREATE TABLE FormResponse (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FormId INT,
    Response NVARCHAR(MAX),
    Email VARCHAR(150) Null,
    AnswerMasterId INT,
    Active BIT CONSTRAINT DF_FormResponse_Active DEFAULT(1),
    CreatedOn DATETIME,
    CreatedBy INT,
    ModifiedBy INT,
    ModifiedOn DATETIME,
    DeletedOn DATETIME,
    DeletedBy INT,
    FOREIGN KEY (FormId) REFERENCES SourceTemplate(Id),
    FOREIGN KEY (AnswerMasterId) REFERENCES AnswerMaster(Id)
);









INSERT INTO DynamicFormsRole (RoleName, Description) VALUES
('Admin', 'Has access to all functionalities and can manage users.'),
('User', 'Can create and manage forms and view responses.');





-- Inserting an Admin User
INSERT INTO DynamicFormUser (Email, [Password], RoleId, CreatedOn)
VALUES 
('admin@gmail.com', 'pass@123', (SELECT Id FROM DynamicFormsRole WHERE RoleName = 'Admin'), GETDATE());

-- Inserting a Regular User
INSERT INTO DynamicFormUser (Email, [Password], RoleId, CreatedOn)
VALUES 
('user1@gmail.com', 'user1@123', (SELECT Id FROM DynamicFormsRole WHERE RoleName = 'User'), GETDATE());

-- Inserting another Regular User
INSERT INTO DynamicFormUser (Email, [Password], RoleId, CreatedOn)
VALUES 
('user2@gmail.com', 'user2@123', (SELECT Id FROM DynamicFormsRole WHERE RoleName = 'User'), GETDATE());




-- Inserting static values into the AnswerType table
INSERT INTO AnswerType (TypeName, CreatedOn, CreatedBy)
VALUES
('text', GETDATE(), 1),
('number', GETDATE(), 1),
('multi-select', GETDATE(), 1),
('checkbox', GETDATE(), 1),
('dropdown', GETDATE(), 1),
('radio', GETDATE(), 1),
('date', GETDATE(), 1);






SELECT * FROM DynamicFormsRole;
SELECT * FROM DynamicFormUser;
SELECT * FROM SourceTemplate;
SELECT * FROM TemplateSection;

SELECT * FROM AnswerType;
SELECT * FROM FormQuestions;
SELECT * FROM AnswerOptions;
SELECT * FROM AnswerMaster;
Select * FROM QuestionSectionMapping;
SELECT * FROM FormResponse;





-- 1. Drop the FormResponse table
DROP TABLE IF EXISTS FormResponse;

-- 2. Drop the AnswerMaster table
DROP TABLE IF EXISTS AnswerMaster;

-- 3. Drop the AnswerOptions table
DROP TABLE IF EXISTS AnswerOptions;

-- 4. Drop the QuestionSectionMapping table
DROP TABLE IF EXISTS QuestionSectionMapping;

-- 5. Drop the FormQuestions table
DROP TABLE IF EXISTS FormQuestions;

-- 6. Drop the TemplateSection table
DROP TABLE IF EXISTS TemplateSection;

-- 7. Drop the SourceTemplate table
DROP TABLE IF EXISTS SourceTemplate;

-- 8. Drop the DynamicFormUser table
DROP TABLE IF EXISTS DynamicFormUser;

-- 9. Drop the AnswerType table
DROP TABLE IF EXISTS AnswerType;

--10. Drop the DynamicFormsRole table
DROP TABLE IF EXISTS DynamicFormsRole;



