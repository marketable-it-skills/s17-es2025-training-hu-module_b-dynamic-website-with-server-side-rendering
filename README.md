# Module B - SkillShare Academy Administrative Interface

**Dynamic Website with Server-Side Rendering**

## Overview

Create a comprehensive administrative interface for SkillShare Academy, a credit-based learning platform. This server-side rendered application allows platform administrators and mentors to manage learners, courses, mentorship programs, and the credit system.

## Key Features

- **Role-based Authentication**: Admin and mentor access levels
- **Learner Management**: Complete learner account oversight and credit management
- **Course Administration**: Full CRUD operations for courses and chapters
- **Mentor Coordination**: Mentor approval, rate setting, and performance monitoring
- **Credit System Oversight**: Platform-wide credit flow and transaction management
- **Analytics Dashboard**: Comprehensive reporting and platform insights

## Technical Stack

- **Backend**: Laravel 11.x or Express.js 4.18+
- **Database**: MySQL 8.0
- **Templating**: Blade, EJS, or Handlebars
- **Deployment**: Docker with docker-compose
- **Security**: OWASP compliance with role-based access control

## Quick Start

1. **Clone and Setup**
   ```bash
   git clone <repository-url>
   cd es2025-s17-training-competition-hu-module_b
   cp .env.example .env
   ```

2. **Start with Docker**
   ```bash
   docker-compose up -d
   ```

3. **Initialize Database**
   ```bash
   docker-compose exec app npm run migrate
   docker-compose exec app npm run seed
   ```

4. **Access Admin Interface**
   - URL: http://localhost:3000/admin
   - Username: `admin1` | Password: `skills2025admin1`

## Project Structure

```
/
├── project-description.md      # Complete requirements specification
├── development-and-deployment.md  # Technical setup guide
├── metadata.json              # Project metadata
├── marking/                   # Assessment criteria
│   └── marking-scheme.json
└── README.md                 # This file
```

## Assessment Focus

- **Authentication & Security** (30%): Role-based access, OWASP compliance
- **Administrative Functionality** (40%): Complete CRUD operations, data management
- **Database Design** (15%): Normalized schema, data integrity
- **User Interface** (15%): Server-side rendering, responsive design

## Duration

4 hours

## Points

20 total (2+1+4+3+10 across WSOS sections)