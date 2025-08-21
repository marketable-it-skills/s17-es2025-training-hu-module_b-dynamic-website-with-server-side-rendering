# Test Project Outline – Module B – Dynamic Website with Server-Side Rendering

## Competition time

4 hours

## Introduction

This project focuses on creating a dynamic, server-side rendered administrative interface for SkillShare Academy. You will build a management system that platform administrators and mentors use to oversee users, courses, mentorship programs, and the credit-based learning system.

## General Description of Project and Tasks

Competitors will create a server-side rendered administrative website for SkillShare Academy. The system manages platform operations including user accounts, course catalog, mentor coordination, and credit system oversight.

Administrative pages require authentication with appropriate privileges. The interface must implement OWASP security guidelines to protect sensitive user data and platform operations.

Competitors must design a database schema and implement the interface based on provided requirements. Sample data will be provided for import into the normalized database structure.

Module B must use a server-side framework for rendering. Additional frontend libraries for interactivity are permitted, but core rendering must be server-side, not client-side API calls.

## Requirements

Create a server-side rendered administrative interface where administrators manage platform operations, user accounts, course content, and mentor application approval.

Design a database schema and import provided data with sample users, courses, and administrative records. The interface must implement OWASP security guidelines with emphasis on access control and data protection.

### Competitor Information

Module B will be assessed using Google Chrome. Security aspects, administrative functionality, and data management capabilities will be evaluated.

Design aesthetics are secondary to functionality and usability for administrative users. Basic styling following the SkillShare Academy design system (purple-orange-cyan color scheme) is expected.

### Sample Data Import & Authentication

Import the provided JSON data (`assets/data/data.json`).

JSON data may not be normalized - structure it properly during import.

Set the following passwords for these users:

- Zeus Helmet (admin@ssa.org) - Password: `skills2025admin1`
- Alice Johnson (alice@example.com) - Password: `WtfiA?`

You can create random passwords for the other imported users.

Passwords must be securely hashed in the database.

**Provide a SQL dump of your database** in the `db/db-dump.sql` file in your solution repository.

### Website Requirements

#### Administrative Interface Layout

The administrative interface must include these core elements:

**Site Header:**

- SkillShare Academy branding and logo
- Navbar for navigation between pages
- User information display showing logged-in admin name
- Logout button accessible from all pages

**Menu and Navigation:**

- Dashboard (landing page after login)
- Learner Management
- Course Management
- Mentor Management

**Login System:**

- Dedicated login page with username/password form
- Redirect after successful authentication
- Only users with admin role can log in
- Error messaging for invalid credentials

**Page Layout:**

- Consistent header and navigation across all pages
- Main content area with page-specific functionality
- Desktop layout optimized for administrative tasks

#### Admin Dashboard

**URL:** `/dashboard` (root `/` should redirect to `/dashboard`)

Display platform overview including:

- Statistics: display counts of total registered learners, total courses, active mentors, and total credits earned. Also show the changes in registered learners, mentors, and total credits earned over the past 7 days.
- Quick access navigation to learner management, course management, and mentor management pages
- Last 6 activities: display a simple table with the following columns:
  - Activity (Learner registration, Mentor registration, Chapter completed)
  - Learner/Mentor (name of the person who performed the activity)
  - Time (relative time format: 1h ago, 2d ago, 1w ago, etc.)

Example Recent Activities Table:

| Activity             | Learner/Mentor | Time   |
| -------------------- | -------------- | ------ |
| Learner registration | Rachel Miller  | 2h ago |
| Chapter completed    | Tom Davis      | 1d ago |
| Chapter completed    | Anna White     | 3d ago |
| Mentor registration  | Michael Chen   | 1w ago |
| Chapter completed    | Rachel Miller  | 2w ago |
| Chapter completed    | Sophia Lee     | 6w ago |

#### Learner Management

- View all learners with search/filtering capabilities:
  - Search by name or email using a single search input field
  - Filter by account status: All, Active, Suspended (dropdown or radio buttons, default: "All")
  - Clear all filters button to reset search and filter criteria
- Pagination: Display 10 learners per page with navigation controls (Previous/Next, page numbers)
- Account details: name, email, chapters completed, credits earned
- Account status management: buttons to suspend and enable users

#### Course Management

- Display all courses with the following details: title, description, difficulty, number of total chapters, and total credits.
- Additional administrator functions:
  - Create a new course
  - Edit a course. On the form, display an additional button for editing the associated chapters. This button should be inactive because this functionality will be implemented later.
  - Delete a course. Before deleting a course, ask for user confirmation. Do not use the default browser popup window for this confirmation. When a course is deleted, all associated chapters should also be deleted, but the chapter completion records should be preserved.

#### Mentor Management

- Display all mentors with the following details: name, hourly credit rate, years of experience, average rating, approval status, and a button for approving pending mentor applications to activate their accounts.

### Security Requirements

OWASP guidelines with administrative security focus:

- Secure password storage (hashing)
- Role-based access control
- Input validation and sanitization
- Protection against SQL injection, XSS, CSRF
- Session management with timeout controls
- Administrative audit logging
- Data protection for PII

### Technical Specifications

- **Framework**: Approved server-side framework
- **Database**: MySQL with administrative schema design
- **Security**: Enhanced OWASP compliance for administrative applications

## Assessment

Assessment using Google Chrome will evaluate administrative functionality, security implementation, role-based access control, database design, and code quality.

## Mark distribution

| WSOS SECTION | Description                            | Points |
| ------------ | -------------------------------------- | ------ |
| 1            | Work organization and self-management  | 2      |
| 2            | Communication and interpersonal skills | 1      |
| 3            | Design Implementation                  | 4      |
| 4            | Front-End Development                  | 3      |
| 5            | Back-End Development                   | 10     |
|              |                                        |        |
| **Total**    |                                        | 20     |
