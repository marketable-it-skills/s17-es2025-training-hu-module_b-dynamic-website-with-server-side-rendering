-- SkillShare Academy Sample Data MySQL Dump
-- Generated on: 2025-08-09T18:53:55.444Z
-- 
-- Database: skillshare_academy
-- ======================================================
SET
  NAMES utf8mb4;

SET
  time_zone = '+00:00';

SET
  foreign_key_checks = 0;

SET
  sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

-- Create database
CREATE DATABASE IF NOT EXISTS `skillshare_academy_3` DEFAULT CHARACTER
SET
  utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `skillshare_academy_3`;

-- ======================================================
-- Table structure
-- ======================================================
DROP TABLE IF EXISTS `users`;

CREATE TABLE
  `users` (
    `id` int NOT NULL AUTO_INCREMENT,
    `username` varchar(100) NOT NULL UNIQUE,
    `email` varchar(255) NOT NULL UNIQUE,
    `password_hash` varchar(255) NOT NULL,
    `role` enum ('user', 'mentor', 'admin') NOT NULL DEFAULT 'user',
    `first_name` varchar(100) DEFAULT NULL,
    `last_name` varchar(100) DEFAULT NULL,
    `registration_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_login` datetime DEFAULT NULL,
    `status` enum ('active', 'suspended', 'deleted') NOT NULL DEFAULT 'active',
    `credit_balance` int NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_username` (`username`),
    KEY `idx_email` (`email`),
    KEY `idx_role` (`role`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `courses`;

CREATE TABLE
  `courses` (
    `id` int NOT NULL AUTO_INCREMENT,
    `title` varchar(200) NOT NULL,
    `description` text,
    `total_credits` int NOT NULL DEFAULT 0,
    `difficulty_level` enum ('beginner', 'intermediate', 'advanced') NOT NULL DEFAULT 'beginner',
    `estimated_hours` int DEFAULT NULL,
    `status` enum ('draft', 'active', 'archived') NOT NULL DEFAULT 'draft',
    `category` varchar(100) DEFAULT NULL,
    `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `instructor_name` varchar(100) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_status` (`status`),
    KEY `idx_category` (`category`),
    KEY `idx_difficulty` (`difficulty_level`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `chapters`;

CREATE TABLE
  `chapters` (
    `id` int NOT NULL AUTO_INCREMENT,
    `course_id` int NOT NULL,
    `title` varchar(200) NOT NULL,
    `description` text,
    `credit_reward` int NOT NULL DEFAULT 0,
    `chapter_order` int NOT NULL DEFAULT 1,
    `estimated_minutes` int DEFAULT NULL,
    `content_type` enum ('video_text', 'hands_on', 'quiz', 'project') NOT NULL DEFAULT 'video_text',
    PRIMARY KEY (`id`),
    KEY `idx_course_id` (`course_id`),
    KEY `idx_order` (`chapter_order`),
    CONSTRAINT `fk_chapters_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `mentors`;

CREATE TABLE
  `mentors` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` int NOT NULL,
    `expertise_areas` text,
    `hourly_credit_rate` int NOT NULL DEFAULT 10,
    `bio` text,
    `years_experience` int DEFAULT NULL,
    `availability_status` enum ('available', 'limited', 'unavailable') NOT NULL DEFAULT 'available',
    `approval_status` enum ('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    `approval_date` datetime DEFAULT NULL,
    `total_sessions_completed` int NOT NULL DEFAULT 0,
    `average_rating` decimal(3, 2) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_status` (`approval_status`),
    KEY `idx_availability` (`availability_status`),
    CONSTRAINT `fk_mentors_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `enrollments`;

CREATE TABLE
  `enrollments` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` int NOT NULL,
    `course_id` int NOT NULL,
    `enrollment_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `progress_percentage` int NOT NULL DEFAULT 0,
    `completed_chapters` int NOT NULL DEFAULT 0,
    `total_chapters` int NOT NULL DEFAULT 0,
    `completion_date` datetime DEFAULT NULL,
    `status` enum ('enrolled', 'in_progress', 'completed', 'dropped') NOT NULL DEFAULT 'enrolled',
    `last_activity` datetime DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_enrollment` (`user_id`, `course_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_course_id` (`course_id`),
    KEY `idx_status` (`status`),
    CONSTRAINT `fk_enrollments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_enrollments_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `transactions`;

CREATE TABLE
  `transactions` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` int NOT NULL,
    `amount` int NOT NULL,
    `transaction_type` enum (
      'credit_earned',
      'credit_spent',
      'manual_adjustment'
    ) NOT NULL,
    `description` text,
    `related_entity_type` enum (
      'course',
      'chapter',
      'mentor_session',
      'manual_adjustment'
    ) DEFAULT NULL,
    `related_entity_id` int DEFAULT NULL,
    `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `processed_by` varchar(100) DEFAULT 'system',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_type` (`transaction_type`),
    KEY `idx_created` (`created_at`),
    CONSTRAINT `fk_transactions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `sessions`;

CREATE TABLE
  `sessions` (
    `id` int NOT NULL AUTO_INCREMENT,
    `mentor_id` int NOT NULL,
    `student_id` int DEFAULT NULL,
    `session_date` date NOT NULL,
    `session_time` time NOT NULL,
    `status` enum ('available', 'booked', 'completed', 'cancelled') NOT NULL DEFAULT 'available',
    `credit_cost` int NOT NULL,
    `topic` varchar(200) DEFAULT NULL,
    `student_rating` int DEFAULT NULL,
    `student_feedback` text DEFAULT NULL,
    `mentor_notes` text DEFAULT NULL,
    `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_mentor_id` (`mentor_id`),
    KEY `idx_student_id` (`student_id`),
    KEY `idx_status` (`status`),
    KEY `idx_date` (`session_date`),
    CONSTRAINT `fk_sessions_mentor` FOREIGN KEY (`mentor_id`) REFERENCES `mentors` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_sessions_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ======================================================
-- Data for tables
-- ======================================================
-- Data for table `users`
INSERT INTO
  `users`
VALUES
  (
    1,
    'admin1',
    'admin1@skillshare.academy',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'admin',
    'System',
    'Administrator',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    0
  ),
  (
    2,
    'mentor1',
    'mentor1@skillshare.academy',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'mentor',
    'Sarah',
    'Johnson',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    0
  ),
  (
    3,
    'mentor2',
    'mentor2@skillshare.academy',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'mentor',
    'Michael',
    'Chen',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    0
  ),
  (
    4,
    'learner1',
    'learner1@skillshare.academy',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'user',
    'Emma',
    'Wilson',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    127
  ),
  (
    5,
    'learner2',
    'learner2@skillshare.academy',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'user',
    'David',
    'Brown',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    89
  ),
  (
    6,
    'alex_dev',
    'alex.dev@email.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'user',
    'Alex',
    'Rodriguez',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    203
  ),
  (
    7,
    'maria_data',
    'maria.data@email.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'user',
    'Maria',
    'Garcia',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    156
  ),
  (
    8,
    'john_ui',
    'john.ui@email.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'user',
    'John',
    'Thompson',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    74
  ),
  (
    9,
    'linda_pm',
    'linda.pm@email.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'user',
    'Linda',
    'Anderson',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    245
  ),
  (
    10,
    'robert_qa',
    'robert.qa@email.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'user',
    'Robert',
    'Martinez',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    92
  ),
  (
    11,
    'sophia_ai',
    'sophia.ai@email.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'user',
    'Sophia',
    'Lee',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    318
  ),
  (
    12,
    'james_sec',
    'james.sec@email.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'user',
    'James',
    'Taylor',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    67
  ),
  (
    13,
    'anna_cloud',
    'anna.cloud@email.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'user',
    'Anna',
    'White',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    189
  ),
  (
    14,
    'tom_mobile',
    'tom.mobile@email.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'user',
    'Tom',
    'Davis',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    134
  ),
  (
    15,
    'rachel_analyst',
    'rachel.analyst@email.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6',
    'user',
    'Rachel',
    'Miller',
    '2024-01-01 10:00:00',
    NULL,
    'active',
    78
  );

-- Data for table `courses`
INSERT INTO
  `courses`
VALUES
  (
    1,
    'JavaScript Fundamentals',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    2,
    'React Development Bootcamp',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    3,
    'Python for Data Analysis',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    4,
    'Database Design Principles',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    5,
    'UI/UX Design Essentials',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    6,
    'DevOps with Docker',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    7,
    'Mobile App Development',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    8,
    'Machine Learning Basics',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    9,
    'Cloud Architecture AWS',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    10,
    'Cybersecurity Fundamentals',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    11,
    'API Development REST',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    12,
    'Agile Project Management',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    13,
    'Advanced CSS Techniques',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    14,
    'Node.js Backend Systems',
    NULL,
    NULL,
    NULL,
    NULL,
    'active',
    NULL,
    NULL,
    NULL
  ),
  (
    15,
    'Quality Assurance Testing',
    NULL,
    NULL,
    NULL,
    NULL,
    'draft',
    NULL,
    NULL,
    NULL
  );

-- Data for table `chapters`
INSERT INTO
  `chapters`
VALUES
  (
    1,
    1,
    'Variables and Data Types',
    'Learn JavaScript variable declarations and primitive data types',
    5,
    NULL,
    NULL,
    NULL
  ),
  (
    2,
    1,
    'Functions and Scope',
    'Master function declarations and understanding scope in JavaScript',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    3,
    1,
    'DOM Manipulation',
    'Interactive web page manipulation using JavaScript DOM API',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    4,
    2,
    'Component Architecture',
    'Understanding React components and component lifecycle',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    5,
    2,
    'State and Props',
    'Managing component state and passing props between components',
    5,
    NULL,
    NULL,
    NULL
  ),
  (
    6,
    2,
    'Event Handling',
    'Handling user interactions and form submissions in React',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    7,
    3,
    'Pandas Fundamentals',
    'Data manipulation and analysis using pandas library',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    8,
    3,
    'NumPy Arrays',
    'Numerical computing and array operations with NumPy',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    9,
    3,
    'Data Visualization',
    'Creating charts and graphs with matplotlib and seaborn',
    5,
    NULL,
    NULL,
    NULL
  ),
  (
    10,
    4,
    'Database Normalization',
    'Understanding database normalization principles and forms',
    5,
    NULL,
    NULL,
    NULL
  ),
  (
    11,
    4,
    'SQL Query Optimization',
    'Writing efficient SQL queries and understanding indexes',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    12,
    4,
    'Relationship Design',
    'Designing foreign keys and database relationships',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    13,
    5,
    'Design Principles',
    'Fundamental UI/UX design principles and best practices',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    14,
    5,
    'User Research Methods',
    'Conducting user research and usability testing',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    15,
    5,
    'Prototyping Tools',
    'Creating wireframes and prototypes using design tools',
    5,
    NULL,
    NULL,
    NULL
  ),
  (
    16,
    6,
    'Container Fundamentals',
    'Understanding Docker containers and containerization',
    5,
    NULL,
    NULL,
    NULL
  ),
  (
    17,
    6,
    'Docker Compose',
    'Orchestrating multi-container applications with Docker Compose',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    18,
    6,
    'CI/CD Pipelines',
    'Setting up continuous integration and deployment workflows',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    19,
    7,
    'React Native Setup',
    'Setting up React Native development environment',
    5,
    NULL,
    NULL,
    NULL
  ),
  (
    20,
    7,
    'Navigation and Routing',
    'Implementing navigation between screens in mobile apps',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    21,
    7,
    'Native API Integration',
    'Accessing device APIs like camera and GPS',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    22,
    8,
    'ML Algorithms Overview',
    'Introduction to supervised and unsupervised learning',
    5,
    NULL,
    NULL,
    NULL
  ),
  (
    23,
    8,
    'Data Preprocessing',
    'Cleaning and preparing data for machine learning models',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    24,
    8,
    'Model Evaluation',
    'Evaluating model performance and avoiding overfitting',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    25,
    9,
    'AWS Core Services',
    'Understanding EC2, S3, and other foundational AWS services',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    26,
    9,
    'Auto Scaling and Load Balancing',
    'Implementing scalable architecture with AWS services',
    5,
    NULL,
    NULL,
    NULL
  ),
  (
    27,
    9,
    'Security Best Practices',
    'Securing cloud applications and infrastructure',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    28,
    10,
    'Threat Modeling',
    'Identifying and analyzing potential security threats',
    5,
    NULL,
    NULL,
    NULL
  ),
  (
    29,
    10,
    'Secure Coding Practices',
    'Writing secure code and preventing common vulnerabilities',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    30,
    10,
    'Security Testing',
    'Performing security audits and penetration testing',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    31,
    12,
    'Scrum Framework',
    'Understanding Scrum roles, events, and artifacts',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    32,
    12,
    'Sprint Planning',
    'Planning and estimating work for development sprints',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    33,
    12,
    'Retrospectives',
    'Conducting effective retrospectives and continuous improvement',
    5,
    NULL,
    NULL,
    NULL
  ),
  (
    34,
    13,
    'CSS Grid Layout',
    'Mastering CSS Grid for complex responsive layouts',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    35,
    13,
    'Flexbox Advanced',
    'Advanced flexbox techniques and layout patterns',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    36,
    13,
    'CSS Animations',
    'Creating smooth animations and transitions with CSS',
    5,
    NULL,
    NULL,
    NULL
  ),
  (
    37,
    15,
    'Test Strategy',
    'Developing comprehensive testing strategies and test plans',
    3,
    NULL,
    NULL,
    NULL
  ),
  (
    38,
    15,
    'Automated Testing',
    'Implementing automated testing frameworks and tools',
    4,
    NULL,
    NULL,
    NULL
  ),
  (
    39,
    15,
    'Quality Metrics',
    'Measuring and improving software quality metrics',
    5,
    NULL,
    NULL,
    NULL
  );

-- Data for table `mentors`
INSERT INTO
  `mentors`
VALUES
  (
    2,
    2,
    'Frontend Development,React,JavaScript,UI Design',
    12,
    'Senior frontend developer with 8+ years experience in React and modern web technologies. Passionate about teaching clean code practices and component architecture.',
    8,
    'available',
    'approved',
    '2024-02-25 15:30:00',
    47,
    4.8
  ),
  (
    3,
    3,
    'Backend Systems,Node.js,Database Design,API Development',
    15,
    'Full-stack engineer specializing in scalable backend systems and API architecture. Expert in microservices and cloud deployment strategies.',
    10,
    'available',
    'approved',
    '2024-03-15 11:20:00',
    38,
    4.9
  ),
  (
    4,
    6,
    'DevOps,AWS,Docker,CI/CD',
    14,
    'DevOps architect with extensive experience in cloud infrastructure and automation. Helps teams implement efficient deployment pipelines.',
    7,
    'available',
    'approved',
    '2024-04-10 09:45:00',
    29,
    4.7
  ),
  (
    5,
    7,
    'Data Science,Python,Machine Learning,Analytics',
    13,
    'Data scientist with strong background in ML algorithms and statistical analysis. Specializes in practical applications of AI in business.',
    6,
    'available',
    'approved',
    '2024-05-20 14:15:00',
    22,
    4.6
  ),
  (
    6,
    8,
    'Mobile Development,React Native,iOS,Android',
    11,
    'Mobile app developer with expertise in cross-platform development. Published 15+ apps with millions of downloads.',
    5,
    'available',
    'approved',
    '2024-06-30 16:00:00',
    31,
    4.8
  ),
  (
    7,
    9,
    'Cybersecurity,Ethical Hacking,Security Auditing',
    15,
    'Information security expert with focus on web application security and penetration testing. CISSP certified.',
    9,
    'available',
    'approved',
    '2024-07-15 12:30:00',
    18,
    4.9
  ),
  (
    8,
    10,
    'Project Management,Agile,Scrum,Leadership',
    10,
    'Certified Scrum Master and PMP with 12+ years leading software development teams. Expert in agile transformation.',
    12,
    'available',
    'approved',
    '2024-08-05 10:10:00',
    55,
    4.7
  ),
  (
    9,
    11,
    'UI/UX Design,Figma,User Research,Prototyping',
    9,
    'UX designer with strong background in user research and design thinking. Worked with startups and Fortune 500 companies.',
    4,
    'available',
    'approved',
    '2024-09-12 13:50:00',
    26,
    4.5
  ),
  (
    10,
    12,
    'Quality Assurance,Test Automation,Selenium',
    8,
    'QA engineer specializing in automated testing frameworks and quality processes. Expert in TDD and BDD methodologies.',
    6,
    'limited',
    'approved',
    '2024-10-20 15:25:00',
    19,
    4.6
  ),
  (
    11,
    13,
    'Cloud Architecture,Azure,Kubernetes,Microservices',
    14,
    'Cloud solutions architect with deep expertise in container orchestration and serverless technologies.',
    8,
    'available',
    'pending',
    '2024-11-15 11:40:00',
    0,
    0.0
  ),
  (
    12,
    14,
    'Blockchain,Smart Contracts,Web3,Cryptocurrency',
    13,
    'Blockchain developer with experience in DeFi protocols and smart contract development. Early adopter of Web3 technologies.',
    3,
    'available',
    'pending',
    '2024-12-01 09:20:00',
    0,
    0.0
  ),
  (
    13,
    15,
    'Game Development,Unity,C#,3D Graphics',
    11,
    'Game developer with 7+ years creating mobile and PC games. Expert in Unity engine and game design principles.',
    7,
    'unavailable',
    'approved',
    '2024-08-25 14:35:00',
    12,
    4.4
  );

-- Data for table `enrollments`
INSERT INTO
  `enrollments`
VALUES
  (
    1,
    4,
    1,
    '2024-06-08 10:30:00',
    100,
    9,
    9,
    '2024-06-15 16:35:00',
    'completed',
    '2024-06-15 16:35:00'
  ),
  (
    2,
    5,
    2,
    '2024-07-15 14:20:00',
    25,
    2,
    8,
    NULL,
    'in_progress',
    '2024-07-22 13:20:00'
  ),
  (
    3,
    6,
    3,
    '2024-08-01 09:45:00',
    100,
    10,
    10,
    '2024-08-25 14:20:00',
    'completed',
    '2024-08-25 14:20:00'
  ),
  (
    4,
    6,
    4,
    '2024-08-30 11:15:00',
    12,
    1,
    8,
    NULL,
    'in_progress',
    '2024-09-02 09:10:00'
  ),
  (
    5,
    7,
    5,
    '2024-08-18 13:30:00',
    100,
    7,
    7,
    '2024-09-05 11:15:00',
    'completed',
    '2024-09-05 11:15:00'
  ),
  (
    6,
    8,
    1,
    '2024-09-05 16:45:00',
    25,
    2,
    9,
    NULL,
    'in_progress',
    '2024-09-12 14:30:00'
  ),
  (
    7,
    9,
    12,
    '2024-09-18 08:20:00',
    100,
    6,
    6,
    '2024-10-10 16:20:00',
    'completed',
    '2024-10-10 16:20:00'
  ),
  (
    8,
    10,
    15,
    '2024-10-02 12:40:00',
    25,
    2,
    8,
    NULL,
    'in_progress',
    '2024-10-08 11:50:00'
  ),
  (
    9,
    11,
    8,
    '2024-10-20 15:10:00',
    100,
    10,
    10,
    '2024-11-15 12:45:00',
    'completed',
    '2024-11-15 12:45:00'
  ),
  (
    10,
    12,
    10,
    '2024-11-15 09:35:00',
    12,
    1,
    8,
    NULL,
    'in_progress',
    '2024-11-18 10:20:00'
  ),
  (
    11,
    13,
    9,
    '2024-12-01 14:25:00',
    25,
    2,
    9,
    NULL,
    'in_progress',
    '2024-12-10 09:45:00'
  ),
  (
    12,
    14,
    7,
    '2024-12-18 11:50:00',
    12,
    1,
    8,
    NULL,
    'in_progress',
    '2024-12-20 11:25:00'
  ),
  (
    13,
    15,
    13,
    '2024-12-28 16:15:00',
    12,
    1,
    5,
    NULL,
    'in_progress',
    '2024-12-30 14:15:00'
  ),
  (
    14,
    4,
    2,
    '2024-07-01 10:00:00',
    0,
    0,
    8,
    NULL,
    'enrolled',
    '2024-07-01 10:00:00'
  ),
  (
    15,
    5,
    3,
    '2024-08-15 13:45:00',
    0,
    0,
    10,
    NULL,
    'enrolled',
    '2024-08-15 13:45:00'
  ),
  (
    16,
    6,
    7,
    '2024-09-20 15:30:00',
    0,
    0,
    8,
    NULL,
    'enrolled',
    '2024-09-20 15:30:00'
  ),
  (
    17,
    7,
    8,
    '2024-10-05 12:20:00',
    0,
    0,
    10,
    NULL,
    'enrolled',
    '2024-10-05 12:20:00'
  ),
  (
    18,
    8,
    11,
    '2024-10-25 09:15:00',
    0,
    0,
    7,
    NULL,
    'enrolled',
    '2024-10-25 09:15:00'
  ),
  (
    19,
    9,
    6,
    '2024-11-10 14:40:00',
    0,
    0,
    11,
    NULL,
    'enrolled',
    '2024-11-10 14:40:00'
  ),
  (
    20,
    10,
    4,
    '2024-11-25 11:30:00',
    0,
    0,
    8,
    NULL,
    'enrolled',
    '2024-11-25 11:30:00'
  ),
  (
    21,
    11,
    9,
    '2024-12-05 16:20:00',
    0,
    0,
    9,
    NULL,
    'enrolled',
    '2024-12-05 16:20:00'
  ),
  (
    22,
    12,
    14,
    '2024-12-15 13:10:00',
    0,
    0,
    12,
    NULL,
    'enrolled',
    '2024-12-15 13:10:00'
  ),
  (
    23,
    13,
    6,
    '2024-12-20 10:45:00',
    0,
    0,
    11,
    NULL,
    'enrolled',
    '2024-12-20 10:45:00'
  );

-- Data for table `transactions`
INSERT INTO
  `transactions`
VALUES
  (
    1,
    4,
    5,
    'credit_earned',
    'Completed Chapter 1 of JavaScript Fundamentals',
    'chapter',
    1,
    '2024-06-10 14:20:00',
    'system'
  ),
  (
    2,
    4,
    4,
    'credit_earned',
    'Completed Chapter 2 of JavaScript Fundamentals',
    'chapter',
    2,
    '2024-06-12 09:15:00',
    'system'
  ),
  (
    3,
    4,
    3,
    'credit_earned',
    'Completed Chapter 3 of JavaScript Fundamentals',
    'chapter',
    3,
    '2024-06-15 16:30:00',
    'system'
  ),
  (
    4,
    5,
    4,
    'credit_earned',
    'Completed Chapter 1 of React Development Bootcamp',
    'chapter',
    4,
    '2024-07-18 11:45:00',
    'system'
  ),
  (
    5,
    5,
    5,
    'credit_earned',
    'Completed Chapter 2 of React Development Bootcamp',
    'chapter',
    5,
    '2024-07-22 13:20:00',
    'system'
  ),
  (
    6,
    6,
    3,
    'credit_earned',
    'Completed Chapter 1 of Python for Data Analysis',
    'chapter',
    7,
    '2024-08-05 10:30:00',
    'system'
  ),
  (
    7,
    6,
    4,
    'credit_earned',
    'Completed Chapter 2 of Python for Data Analysis',
    'chapter',
    8,
    '2024-08-08 15:45:00',
    'system'
  ),
  (
    8,
    6,
    5,
    'credit_earned',
    'Completed Chapter 1 of Database Design Principles',
    'chapter',
    10,
    '2024-09-02 09:10:00',
    'system'
  ),
  (
    9,
    7,
    4,
    'credit_earned',
    'Completed Chapter 1 of UI/UX Design Essentials',
    'chapter',
    13,
    '2024-08-20 12:00:00',
    'system'
  ),
  (
    10,
    7,
    3,
    'credit_earned',
    'Completed Chapter 2 of UI/UX Design Essentials',
    'chapter',
    14,
    '2024-08-23 16:25:00',
    'system'
  ),
  (
    14,
    4,
    -24,
    'credit_spent',
    'Mentorship session with Sarah Thompson - 2 hours',
    'mentor_session',
    1,
    '2024-06-20 14:00:00',
    'system'
  ),
  (
    15,
    5,
    -15,
    'credit_spent',
    'Mentorship session with Michael Rodriguez - 1 hour',
    'mentor_session',
    2,
    '2024-07-25 10:30:00',
    'system'
  ),
  (
    16,
    6,
    -36,
    'credit_spent',
    'Mentorship session with Sarah Thompson - 3 hours',
    'mentor_session',
    3,
    '2024-09-10 15:20:00',
    'system'
  ),
  (
    17,
    8,
    5,
    'credit_earned',
    'Completed Chapter 1 of JavaScript Fundamentals',
    'chapter',
    1,
    '2024-09-08 08:45:00',
    'system'
  ),
  (
    18,
    8,
    4,
    'credit_earned',
    'Completed Chapter 2 of JavaScript Fundamentals',
    'chapter',
    2,
    '2024-09-12 14:30:00',
    'system'
  ),
  (
    19,
    9,
    4,
    'credit_earned',
    'Completed Chapter 1 of Agile Project Management',
    'chapter',
    31,
    '2024-09-20 10:15:00',
    'system'
  ),
  (
    20,
    9,
    3,
    'credit_earned',
    'Completed Chapter 2 of Agile Project Management',
    'chapter',
    32,
    '2024-09-25 13:40:00',
    'system'
  ),
  (
    21,
    10,
    3,
    'credit_earned',
    'Completed Chapter 1 of Quality Assurance Testing',
    'chapter',
    37,
    '2024-10-05 09:25:00',
    'system'
  ),
  (
    22,
    10,
    4,
    'credit_earned',
    'Completed Chapter 2 of Quality Assurance Testing',
    'chapter',
    38,
    '2024-10-08 11:50:00',
    'system'
  ),
  (
    23,
    11,
    5,
    'credit_earned',
    'Completed Chapter 1 of Machine Learning Basics',
    'chapter',
    22,
    '2024-10-25 14:10:00',
    'system'
  ),
  (
    24,
    11,
    4,
    'credit_earned',
    'Completed Chapter 2 of Machine Learning Basics',
    'chapter',
    23,
    '2024-10-30 16:35:00',
    'system'
  ),
  (
    27,
    12,
    3,
    'credit_earned',
    'Completed Chapter 1 of Cybersecurity Fundamentals',
    'chapter',
    28,
    '2024-11-18 10:20:00',
    'system'
  ),
  (
    28,
    13,
    4,
    'credit_earned',
    'Completed Chapter 1 of Cloud Architecture AWS',
    'chapter',
    25,
    '2024-12-05 15:30:00',
    'system'
  ),
  (
    29,
    13,
    5,
    'credit_earned',
    'Completed Chapter 2 of Cloud Architecture AWS',
    'chapter',
    26,
    '2024-12-10 09:45:00',
    'system'
  ),
  (
    30,
    14,
    5,
    'credit_earned',
    'Completed Chapter 1 of Mobile App Development',
    'chapter',
    19,
    '2024-12-20 11:25:00',
    'system'
  ),
  (
    31,
    15,
    3,
    'credit_earned',
    'Completed Chapter 1 of Advanced CSS Techniques',
    'chapter',
    34,
    '2024-12-30 14:15:00',
    'system'
  ),
  (
    32,
    7,
    -30,
    'credit_spent',
    'Mentorship session with DevOps Expert - 2 hours',
    'mentor_session',
    4,
    '2024-09-15 13:00:00',
    'system'
  ),
  (
    33,
    9,
    -20,
    'credit_spent',
    'Mentorship session with Project Manager - 2 hours',
    'mentor_session',
    5,
    '2024-10-20 10:45:00',
    'system'
  ),
  (
    34,
    11,
    -39,
    'credit_spent',
    'Mentorship session with Data Science Expert - 3 hours',
    'mentor_session',
    6,
    '2024-11-25 16:00:00',
    'system'
  ),
  (
    35,
    4,
    50,
    'credit_earned',
    'Admin bonus for chapter completion streak',
    'manual_adjustment',
    0,
    '2024-07-01 12:00:00',
    'admin1'
  ),
  (
    36,
    6,
    25,
    'credit_earned',
    'Community contribution reward',
    'manual_adjustment',
    0,
    '2024-09-15 14:30:00',
    'admin1'
  ),
  (
    37,
    8,
    10,
    'credit_earned',
    'Beta testing participation bonus',
    'manual_adjustment',
    0,
    '2024-09-30 16:45:00',
    'admin1'
  );

-- Data for table `sessions`
INSERT INTO
  `sessions`
VALUES
  (
    1,
    2,
    4,
    '2024-06-20',
    '14:00:00',
    'completed',
    12,
    'React Component Architecture',
    5,
    'Excellent session! Really helped me understand component lifecycle.',
    'Covered hooks and state management in depth',
    '2024-06-18 10:30:00'
  ),
  (
    2,
    3,
    5,
    '2024-07-25',
    '10:30:00',
    'completed',
    15,
    'API Development Best Practices',
    4,
    'Very knowledgeable mentor. Good practical examples.',
    'Discussed RESTful design and authentication patterns',
    '2024-07-23 15:20:00'
  ),
  (
    3,
    2,
    6,
    '2024-09-10',
    '15:20:00',
    'completed',
    12,
    'Advanced React Patterns',
    5,
    'Amazing session! Learned so much about custom hooks.',
    'Student showed great progress, covered advanced concepts',
    '2024-09-08 11:45:00'
  ),
  (
    4,
    4,
    7,
    '2024-09-15',
    '13:00:00',
    'completed',
    14,
    'DevOps Pipeline Setup',
    4,
    'Helpful session on CI/CD. Could use more hands-on examples.',
    'Set up complete GitHub Actions workflow together',
    '2024-09-13 09:30:00'
  ),
  (
    5,
    5,
    9,
    '2024-10-20',
    '10:45:00',
    'completed',
    13,
    'Machine Learning Fundamentals',
    5,
    'Perfect introduction to ML concepts. Very patient mentor.',
    'Covered basic algorithms and practical applications',
    '2024-10-18 16:15:00'
  ),
  (
    6,
    2,
    11,
    '2024-11-25',
    '16:00:00',
    'completed',
    12,
    'JavaScript Performance Optimization',
    4,
    'Good technical depth. Session was very informative.',
    'Analyzed code performance and optimization strategies',
    '2024-11-23 14:20:00'
  ),
  (
    7,
    3,
    4,
    '2024-12-05',
    '09:30:00',
    'completed',
    15,
    'Database Design Patterns',
    5,
    'Exceptional mentor! Really understood my project needs.',
    'Helped design complete database schema for student''s app',
    '2024-12-03 12:10:00'
  ),
  (
    8,
    6,
    8,
    '2024-12-12',
    '11:15:00',
    'completed',
    11,
    'Mobile App User Experience',
    4,
    'Great insights on UX design. Practical advice for my app.',
    'Reviewed app mockups and suggested improvements',
    '2024-12-10 08:45:00'
  ),
  (
    9,
    7,
    10,
    '2024-12-18',
    '14:45:00',
    'completed',
    15,
    'Security Vulnerability Assessment',
    5,
    'Incredibly knowledgeable about security. Eye-opening session.',
    'Conducted security review of student''s web application',
    '2024-12-16 13:30:00'
  ),
  (
    10,
    8,
    12,
    '2024-12-28',
    '10:00:00',
    'completed',
    10,
    'Agile Project Management',
    4,
    'Good overview of Scrum practices. Helpful for my team.',
    'Discussed sprint planning and team dynamics',
    '2024-12-26 15:50:00'
  ),
  (
    11,
    2,
    5,
    '2025-01-15',
    '14:30:00',
    'booked',
    12,
    'React Testing Strategies',
    NULL,
    'NULL',
    'NULL',
    '2025-01-10 11:20:00'
  ),
  (
    12,
    3,
    6,
    '2025-01-18',
    '10:15:00',
    'booked',
    15,
    'Microservices Architecture',
    NULL,
    'NULL',
    'NULL',
    '2025-01-12 16:45:00'
  ),
  (
    13,
    4,
    7,
    '2025-01-22',
    '15:45:00',
    'booked',
    14,
    'Kubernetes Deployment',
    NULL,
    'NULL',
    'NULL',
    '2025-01-15 09:10:00'
  ),
  (
    14,
    5,
    9,
    '2025-01-25',
    '11:30:00',
    'booked',
    13,
    'Deep Learning Applications',
    NULL,
    'NULL',
    'NULL',
    '2025-01-18 14:25:00'
  ),
  (
    15,
    6,
    8,
    '2025-01-30',
    '13:20:00',
    'booked',
    11,
    'Cross-Platform Development',
    NULL,
    'NULL',
    'NULL',
    '2025-01-22 10:55:00'
  ),
  (
    16,
    2,
    NULL,
    '2025-02-05',
    '16:00:00',
    'available',
    12,
    'React Advanced Patterns',
    NULL,
    'NULL',
    'Available for booking',
    '2025-01-25 12:40:00'
  ),
  (
    17,
    3,
    NULL,
    '2025-02-08',
    '09:45:00',
    'available',
    15,
    'System Architecture Review',
    NULL,
    'NULL',
    'Available for booking',
    '2025-01-28 15:15:00'
  ),
  (
    18,
    4,
    NULL,
    '2025-02-10',
    '14:15:00',
    'available',
    14,
    'Cloud Infrastructure Setup',
    NULL,
    'NULL',
    'Available for booking',
    '2025-01-30 11:30:00'
  ),
  (
    19,
    5,
    NULL,
    '2025-02-12',
    '10:30:00',
    'available',
    13,
    'AI Model Deployment',
    NULL,
    'NULL',
    'Available for booking',
    '2025-02-01 16:20:00'
  ),
  (
    20,
    6,
    NULL,
    '2025-02-15',
    '13:45:00',
    'available',
    11,
    'Mobile Performance Optimization',
    NULL,
    'NULL',
    'Available for booking',
    '2025-02-03 08:50:00'
  ),
  (
    21,
    7,
    NULL,
    '2025-02-18',
    '15:30:00',
    'available',
    15,
    'Penetration Testing Basics',
    NULL,
    'NULL',
    'Available for booking',
    '2025-02-05 14:10:00'
  ),
  (
    22,
    8,
    NULL,
    '2025-02-20',
    '11:00:00',
    'available',
    10,
    'Team Leadership Skills',
    NULL,
    'NULL',
    'Available for booking',
    '2025-02-07 12:25:00'
  ),
  (
    23,
    9,
    NULL,
    '2025-02-22',
    '14:00:00',
    'available',
    9,
    'User Research Methods',
    NULL,
    'NULL',
    'Available for booking',
    '2025-02-10 09:35:00'
  ),
  (
    24,
    10,
    NULL,
    '2025-02-25',
    '16:15:00',
    'available',
    8,
    'Automated Testing Framework',
    NULL,
    'NULL',
    'Available for booking',
    '2025-02-12 13:45:00'
  ),
  (
    25,
    2,
    NULL,
    '2025-02-28',
    '10:45:00',
    'available',
    12,
    'Component Library Design',
    NULL,
    'NULL',
    'Available for booking',
    '2025-02-15 11:50:00'
  );

-- ======================================================
-- Final statements
-- ======================================================
SET
  foreign_key_checks = 1;

-- Update user password hashes (these should be properly hashed in production)
UPDATE users
SET
  password_hash = '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6'
WHERE
  username = 'admin1';

UPDATE users
SET
  password_hash = '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6'
WHERE
  username = 'mentor1';

UPDATE users
SET
  password_hash = '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6'
WHERE
  username = 'mentor2';

UPDATE users
SET
  password_hash = '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6'
WHERE
  username = 'learner1';

UPDATE users
SET
  password_hash = '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6'
WHERE
  username = 'learner2';

-- Add indexes for performance
CREATE INDEX idx_transactions_user_date ON transactions (user_id, created_at);

CREATE INDEX idx_enrollments_user_status ON enrollments (user_id, status);

CREATE INDEX idx_mentors_approval_availability ON mentors (approval_status, availability_status);

-- Add additional indexes for performance
CREATE INDEX idx_sessions_mentor_date ON sessions (mentor_id, session_date);

CREATE INDEX idx_sessions_status_date ON sessions (status, session_date);

-- Summary statistics
SELECT
  'Database setup complete!' as message,
  (
    SELECT
      COUNT(*)
    FROM
      users
  ) as total_users,
  (
    SELECT
      COUNT(*)
    FROM
      courses
  ) as total_courses,
  (
    SELECT
      COUNT(*)
    FROM
      mentors
  ) as total_mentors,
  (
    SELECT
      COUNT(*)
    FROM
      sessions
  ) as total_sessions,
  (
    SELECT
      SUM(credit_balance)
    FROM
      users
  ) as total_credits_in_system;