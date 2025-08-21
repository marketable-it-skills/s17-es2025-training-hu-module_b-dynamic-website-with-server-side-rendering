const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');

// Database and table schemas
const tableSchemas = {
  users: `CREATE TABLE \`users\` (
  \`id\` int NOT NULL AUTO_INCREMENT,
  \`username\` varchar(100) NOT NULL UNIQUE,
  \`email\` varchar(255) NOT NULL UNIQUE,
  \`password_hash\` varchar(255) NOT NULL,
  \`role\` enum('user','mentor','admin') NOT NULL DEFAULT 'user',
  \`first_name\` varchar(100) DEFAULT NULL,
  \`last_name\` varchar(100) DEFAULT NULL,
  \`registration_date\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  \`last_login\` datetime DEFAULT NULL,
  \`status\` enum('active','suspended','deleted') NOT NULL DEFAULT 'active',
  \`credit_balance\` int NOT NULL DEFAULT 0,
  PRIMARY KEY (\`id\`),
  KEY \`idx_username\` (\`username\`),
  KEY \`idx_email\` (\`email\`),
  KEY \`idx_role\` (\`role\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`,

  courses: `CREATE TABLE \`courses\` (
  \`id\` int NOT NULL AUTO_INCREMENT,
  \`title\` varchar(200) NOT NULL,
  \`description\` text,
  \`total_credits\` int NOT NULL DEFAULT 0,
  \`difficulty_level\` enum('beginner','intermediate','advanced') NOT NULL DEFAULT 'beginner',
  \`estimated_hours\` int DEFAULT NULL,
  \`status\` enum('draft','active','archived') NOT NULL DEFAULT 'draft',
  \`category\` varchar(100) DEFAULT NULL,
  \`created_date\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  \`instructor_name\` varchar(100) DEFAULT NULL,
  PRIMARY KEY (\`id\`),
  KEY \`idx_status\` (\`status\`),
  KEY \`idx_category\` (\`category\`),
  KEY \`idx_difficulty\` (\`difficulty_level\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`,

  chapters: `CREATE TABLE \`chapters\` (
  \`id\` int NOT NULL AUTO_INCREMENT,
  \`course_id\` int NOT NULL,
  \`title\` varchar(200) NOT NULL,
  \`description\` text,
  \`credit_reward\` int NOT NULL DEFAULT 0,
  \`chapter_order\` int NOT NULL DEFAULT 1,
  \`estimated_minutes\` int DEFAULT NULL,
  \`content_type\` enum('video_text','hands_on','quiz','project') NOT NULL DEFAULT 'video_text',
  PRIMARY KEY (\`id\`),
  KEY \`idx_course_id\` (\`course_id\`),
  KEY \`idx_order\` (\`chapter_order\`),
  CONSTRAINT \`fk_chapters_course\` FOREIGN KEY (\`course_id\`) REFERENCES \`courses\` (\`id\`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`,

  mentors: `CREATE TABLE \`mentors\` (
  \`id\` int NOT NULL AUTO_INCREMENT,
  \`user_id\` int NOT NULL,
  \`expertise_areas\` text,
  \`hourly_credit_rate\` int NOT NULL DEFAULT 10,
  \`bio\` text,
  \`years_experience\` int DEFAULT NULL,
  \`availability_status\` enum('available','limited','unavailable') NOT NULL DEFAULT 'available',
  \`approval_status\` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  \`approval_date\` datetime DEFAULT NULL,
  \`total_sessions_completed\` int NOT NULL DEFAULT 0,
  \`average_rating\` decimal(3,2) DEFAULT NULL,
  PRIMARY KEY (\`id\`),
  KEY \`idx_user_id\` (\`user_id\`),
  KEY \`idx_status\` (\`approval_status\`),
  KEY \`idx_availability\` (\`availability_status\`),
  CONSTRAINT \`fk_mentors_user\` FOREIGN KEY (\`user_id\`) REFERENCES \`users\` (\`id\`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`,

  enrollments: `CREATE TABLE \`enrollments\` (
  \`id\` int NOT NULL AUTO_INCREMENT,
  \`user_id\` int NOT NULL,
  \`course_id\` int NOT NULL,
  \`enrollment_date\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  \`progress_percentage\` int NOT NULL DEFAULT 0,
  \`completed_chapters\` int NOT NULL DEFAULT 0,
  \`total_chapters\` int NOT NULL DEFAULT 0,
  \`completion_date\` datetime DEFAULT NULL,
  \`status\` enum('enrolled','in_progress','completed','dropped') NOT NULL DEFAULT 'enrolled',
  \`last_activity\` datetime DEFAULT NULL,
  PRIMARY KEY (\`id\`),
  UNIQUE KEY \`unique_enrollment\` (\`user_id\`,\`course_id\`),
  KEY \`idx_user_id\` (\`user_id\`),
  KEY \`idx_course_id\` (\`course_id\`),
  KEY \`idx_status\` (\`status\`),
  CONSTRAINT \`fk_enrollments_user\` FOREIGN KEY (\`user_id\`) REFERENCES \`users\` (\`id\`) ON DELETE CASCADE,
  CONSTRAINT \`fk_enrollments_course\` FOREIGN KEY (\`course_id\`) REFERENCES \`courses\` (\`id\`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`,

  transactions: `CREATE TABLE \`transactions\` (
  \`id\` int NOT NULL AUTO_INCREMENT,
  \`user_id\` int NOT NULL,
  \`amount\` int NOT NULL,
  \`transaction_type\` enum('credit_earned','credit_spent','manual_adjustment') NOT NULL,
  \`description\` text,
  \`related_entity_type\` enum('course','chapter','mentor_session','manual_adjustment') DEFAULT NULL,
  \`related_entity_id\` int DEFAULT NULL,
  \`created_at\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  \`processed_by\` varchar(100) DEFAULT 'system',
  PRIMARY KEY (\`id\`),
  KEY \`idx_user_id\` (\`user_id\`),
  KEY \`idx_type\` (\`transaction_type\`),
  KEY \`idx_created\` (\`created_at\`),
  CONSTRAINT \`fk_transactions_user\` FOREIGN KEY (\`user_id\`) REFERENCES \`users\` (\`id\`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`,

  sessions: `CREATE TABLE \`sessions\` (
  \`id\` int NOT NULL AUTO_INCREMENT,
  \`mentor_id\` int NOT NULL,
  \`student_id\` int DEFAULT NULL,
  \`session_date\` date NOT NULL,
  \`session_time\` time NOT NULL,
  \`status\` enum('available','booked','completed','cancelled') NOT NULL DEFAULT 'available',
  \`credit_cost\` int NOT NULL,
  \`topic\` varchar(200) DEFAULT NULL,
  \`student_rating\` int DEFAULT NULL,
  \`student_feedback\` text DEFAULT NULL,
  \`mentor_notes\` text DEFAULT NULL,
  \`created_at\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (\`id\`),
  KEY \`idx_mentor_id\` (\`mentor_id\`),
  KEY \`idx_student_id\` (\`student_id\`),
  KEY \`idx_status\` (\`status\`),
  KEY \`idx_date\` (\`session_date\`),
  CONSTRAINT \`fk_sessions_mentor\` FOREIGN KEY (\`mentor_id\`) REFERENCES \`mentors\` (\`id\`) ON DELETE CASCADE,
  CONSTRAINT \`fk_sessions_student\` FOREIGN KEY (\`student_id\`) REFERENCES \`users\` (\`id\`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`
};

// Utility functions
function escapeString(str) {
  if (str === null || str === undefined || str === '') return 'NULL';
  return "'" + String(str).replace(/'/g, "''").replace(/\\/g, '\\\\') + "'";
}

function formatDateTime(dateStr) {
  if (!dateStr || dateStr === 'NULL') return 'NULL';
  return escapeString(dateStr);
}

function formatNumber(num) {
  if (num === null || num === undefined || num === '') return 'NULL';
  return isNaN(num) ? 'NULL' : num;
}

// CSV processing functions
function processUsers(data) {
  return data.map(row => {
    // Generate a default password hash for all users (should be properly hashed in production)
    const defaultPasswordHash = '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6';
    const registrationDate = row.registration_date || '2024-01-01 10:00:00';
    
    return `(${row.id}, ${escapeString(row.username)}, ${escapeString(row.email)}, ${escapeString(defaultPasswordHash)}, ${escapeString(row.role)}, ${escapeString(row.first_name)}, ${escapeString(row.last_name)}, ${formatDateTime(registrationDate)}, ${formatDateTime(row.last_login)}, ${escapeString(row.status)}, ${formatNumber(row.credit_balance)})`;
  });
}

function processCourses(data) {
  return data.map(row => {
    return `(${row.id}, ${escapeString(row.title)}, ${escapeString(row.description)}, ${formatNumber(row.total_credits)}, ${escapeString(row.difficulty_level)}, ${formatNumber(row.estimated_hours)}, ${escapeString(row.status)}, ${escapeString(row.category)}, ${formatDateTime(row.created_date)}, ${escapeString(row.instructor_name)})`;
  });
}

function processChapters(data) {
  return data.map(row => {
    return `(${row.id}, ${formatNumber(row.course_id)}, ${escapeString(row.title)}, ${escapeString(row.description)}, ${formatNumber(row.credit_reward)}, ${formatNumber(row.chapter_order)}, ${formatNumber(row.estimated_minutes)}, ${escapeString(row.content_type)})`;
  });
}

function processMentors(data) {
  return data.map(row => {
    return `(${row.id}, ${formatNumber(row.user_id)}, ${escapeString(row.expertise_areas)}, ${formatNumber(row.hourly_credit_rate)}, ${escapeString(row.bio)}, ${formatNumber(row.years_experience)}, ${escapeString(row.availability_status)}, ${escapeString(row.approval_status)}, ${formatDateTime(row.approval_date)}, ${formatNumber(row.total_sessions_completed)}, ${formatNumber(row.average_rating)})`;
  });
}

function processEnrollments(data) {
  return data.map(row => {
    return `(${row.id}, ${formatNumber(row.user_id)}, ${formatNumber(row.course_id)}, ${formatDateTime(row.enrollment_date)}, ${formatNumber(row.progress_percentage)}, ${formatNumber(row.completed_chapters)}, ${formatNumber(row.total_chapters)}, ${formatDateTime(row.completion_date)}, ${escapeString(row.status)}, ${formatDateTime(row.last_activity)})`;
  });
}

function processTransactions(data) {
  return data.map(row => {
    return `(${row.id}, ${formatNumber(row.user_id)}, ${formatNumber(row.amount)}, ${escapeString(row.transaction_type)}, ${escapeString(row.description)}, ${escapeString(row.related_entity_type)}, ${formatNumber(row.related_entity_id)}, ${formatDateTime(row.created_at)}, ${escapeString(row.processed_by)})`;
  });
}

function processSessions(data) {
  return data.map(row => {
    return `(${row.id}, ${formatNumber(row.mentor_id)}, ${formatNumber(row.student_id)}, ${escapeString(row.session_date)}, ${escapeString(row.session_time)}, ${escapeString(row.status)}, ${formatNumber(row.credit_cost)}, ${escapeString(row.topic)}, ${formatNumber(row.student_rating)}, ${escapeString(row.student_feedback)}, ${escapeString(row.mentor_notes)}, ${formatDateTime(row.created_at)})`;
  });
}

// Main conversion function
async function convertCsvToMysql() {
  const dumpFileName = 'skillshare_academy_sample_data.sql';
  const dumpPath = path.join(__dirname, dumpFileName);
  
  console.log('Starting CSV to MySQL conversion...');
  
  // Start building the dump file
  let dumpContent = `-- SkillShare Academy Sample Data MySQL Dump
-- Generated on: ${new Date().toISOString()}
-- 
-- Database: skillshare_academy
-- ======================================================

SET NAMES utf8mb4;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

-- Create database
CREATE DATABASE IF NOT EXISTS \`skillshare_academy\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE \`skillshare_academy\`;

-- ======================================================
-- Table structure
-- ======================================================

`;

  // Add DROP and CREATE statements for each table
  const tableOrder = ['users', 'courses', 'chapters', 'mentors', 'enrollments', 'transactions', 'sessions'];
  
  for (const tableName of tableOrder) {
    dumpContent += `DROP TABLE IF EXISTS \`${tableName}\`;\n`;
    dumpContent += tableSchemas[tableName] + '\n\n';
  }

  dumpContent += `-- ======================================================
-- Data for tables
-- ======================================================

`;

  // Process each CSV file
  const csvFiles = {
    users: 'users.csv',
    courses: 'courses.csv',
    chapters: 'chapters.csv',
    mentors: 'mentors.csv',
    enrollments: 'enrollments.csv',
    transactions: 'transactions.csv',
    sessions: 'sessions.csv'
  };

  const processors = {
    users: processUsers,
    courses: processCourses,
    chapters: processChapters,
    mentors: processMentors,
    enrollments: processEnrollments,
    transactions: processTransactions,
    sessions: processSessions
  };

  for (const tableName of tableOrder) {
    const csvFile = csvFiles[tableName];
    const processor = processors[tableName];
    
    console.log(`Processing ${csvFile}...`);
    
    const data = [];
    
    await new Promise((resolve, reject) => {
      fs.createReadStream(path.join(__dirname, csvFile))
        .pipe(csv())
        .on('data', (row) => {
          data.push(row);
        })
        .on('end', () => {
          console.log(`Parsed ${data.length} rows from ${csvFile}`);
          resolve();
        })
        .on('error', reject);
    });

    if (data.length > 0) {
      const processedRows = processor(data);
      
      dumpContent += `-- Data for table \`${tableName}\`\n`;
      dumpContent += `INSERT INTO \`${tableName}\` VALUES\n`;
      dumpContent += processedRows.join(',\n') + ';\n\n';
    }
  }

  // Add final statements
  dumpContent += `-- ======================================================
-- Final statements
-- ======================================================

SET foreign_key_checks = 1;

-- Update user password hashes (these should be properly hashed in production)
UPDATE users SET password_hash = '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6' WHERE username = 'admin1';
UPDATE users SET password_hash = '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6' WHERE username = 'mentor1';
UPDATE users SET password_hash = '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6' WHERE username = 'mentor2';
UPDATE users SET password_hash = '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6' WHERE username = 'learner1';
UPDATE users SET password_hash = '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKYqNrz1aZ8Hku6' WHERE username = 'learner2';

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
  (SELECT COUNT(*) FROM users) as total_users,
  (SELECT COUNT(*) FROM courses) as total_courses,
  (SELECT COUNT(*) FROM mentors) as total_mentors,
  (SELECT COUNT(*) FROM sessions) as total_sessions,
  (SELECT SUM(credit_balance) FROM users) as total_credits_in_system;
`;

  // Write the dump file
  fs.writeFileSync(dumpPath, dumpContent);
  
  console.log(`✅ MySQL dump file created: ${dumpFileName}`);
  console.log(`📁 Location: ${dumpPath}`);
  console.log('');
  console.log('To import this dump:');
  console.log(`mysql -u root -p < ${dumpFileName}`);
  console.log('');
  console.log('Or with Docker:');
  console.log(`docker exec -i mysql_container mysql -u root -p skillshare_academy < ${dumpFileName}`);
}

// Run the conversion
convertCsvToMysql().catch(console.error);