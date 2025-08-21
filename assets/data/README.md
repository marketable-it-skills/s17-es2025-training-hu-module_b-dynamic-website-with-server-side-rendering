# SkillShare Academy Sample Data

This directory contains CSV sample data and conversion tools for the SkillShare Academy administrative interface (Module B).

## Files Overview

### CSV Data Files
- **`users.csv`** - User accounts (admin, mentors, learners) with credentials and profiles
- **`courses.csv`** - Course catalog with credit values and metadata
- **`chapters.csv`** - Course chapters with individual credit rewards (3-5 credits each)
- **`mentors.csv`** - Mentor profiles with expertise areas and hourly rates (8-15 credits/hour)
- **`enrollments.csv`** - User enrollment data with progress tracking
- **`transactions.csv`** - Credit transaction history (earned/spent credits)

### Conversion Tools
- **`csv-to-mysql.js`** - JavaScript script to convert all CSVs to MySQL dump file
- **`package.json`** - Node.js dependencies for the conversion script

## Quick Usage

### Option 1: Use the MySQL Dump (Recommended)

1. **Generate the MySQL dump file:**
   ```bash
   cd assets/data
   npm install
   npm run convert
   ```

2. **Import into MySQL:**
   ```bash
   mysql -u root -p < skillshare_academy_sample_data.sql
   ```

3. **Or with Docker:**
   ```bash
   docker exec -i mysql_container mysql -u root -p < skillshare_academy_sample_data.sql
   ```

### Option 2: Import CSVs Manually

If you prefer to import the CSV files directly into your application, the data is structured as follows:

#### Test Accounts
- **Admin**: `admin1` / `skills2025admin1`
- **Mentors**: `mentor1` / `skills2025mentor1`, `mentor2` / `skills2025mentor2`  
- **Learners**: `learner1` / `skills2025b1`, `learner2` / `skills2025b2`

## Database Schema

The conversion script creates a complete MySQL database with the following tables:

### Core Tables
- **`users`** - User accounts with role-based access (admin, mentor, user)
- **`courses`** - Course catalog with credit rewards (25-60 credits total)
- **`chapters`** - Course chapters with individual credit rewards (3-5 credits)
- **`mentors`** - Mentor profiles linked to user accounts
- **`enrollments`** - User course enrollments with progress tracking
- **`transactions`** - Credit transaction log with detailed history

### Additional Features
- **Foreign key constraints** for data integrity
- **Indexes** for query performance
- **Sample mentor sessions** referenced in transactions
- **Proper password hashing** for security (bcrypt)

## Data Characteristics

### Credit System
- **Chapter Completion**: 3-5 credits per chapter
- **Course Completion**: 25-60 credits total per course
- **Mentor Sessions**: 8-15 credits per hour
- **Current User Balances**: Range from 67 to 318 credits

### Realistic Relationships
- Users enrolled in multiple courses
- Progress tracking with completed/in-progress/enrolled statuses
- Credit earning and spending history
- Mentor approval workflow (approved, pending, rejected)

### Non-Normalized Data
The CSV files contain some intentionally non-normalized data to simulate real-world scenarios:
- Repeated instructor names across courses
- Mixed data types requiring validation
- Some optional fields with NULL values

## Security Notes

**⚠️ Important**: The sample data includes placeholder password hashes. In production:

1. Use proper bcrypt hashing for all passwords
2. The conversion script sets all passwords to the same hash for testing
3. Implement proper password validation and security policies
4. Never commit real password hashes to version control

## Usage in Module B

This sample data provides:
- **Administrative oversight** - Learner management, course administration
- **Credit system management** - Transaction monitoring, balance adjustments  
- **Mentor coordination** - Approval workflow, rate management
- **Platform analytics** - Enrollment statistics, credit flow analysis
- **Database design challenge** - Normalization and relationship management

The data supports all required functionality for the SkillShare Academy administrative interface while providing realistic complexity for competitors to work with.