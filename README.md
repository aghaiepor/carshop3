# Car Shopping Django Web Application

A comprehensive car shopping web application built with Django and SQL Server, featuring a complete admin panel for content management and Docker deployment.

## Features

- **Car Catalog**: Browse and search cars with advanced filtering
- **Brand Management**: Organize cars by brands with logos
- **Category System**: Categorize vehicles (SUV, Sedan, etc.)
- **Image Gallery**: Multiple images per car with primary image selection
- **Inquiry System**: Customer inquiry form for each car
- **Admin Panel**: Complete Django admin interface for content management
- **Responsive Design**: Mobile-friendly Bootstrap interface
- **Docker Deployment**: Easy deployment with Docker Compose

## Technology Stack

- **Backend**: Django 4.2.7
- **Database**: Microsoft SQL Server
- **Frontend**: Bootstrap 5, HTML5, CSS3
- **Containerization**: Docker & Docker Compose
- **Forms**: Django Crispy Forms with Bootstrap 5

## Installation & Setup

### Prerequisites

- Docker and Docker Compose installed
- Ubuntu 22.04 (or compatible Linux distribution)

### Quick Start

1. **Clone the repository**:
   \`\`\`bash
   git clone <repository-url>
   cd car-shopping-django
   \`\`\`

2. **Build and run with Docker Compose**:
   \`\`\`bash
   docker-compose up --build
   \`\`\`

3. **Create a superuser** (in a new terminal):
   \`\`\`bash
   docker-compose exec web python manage.py createsuperuser
   \`\`\`

4. **Access the application**:
   - Main site: http://localhost:8000
   - Admin panel: http://localhost:8000/admin

### Manual Setup (without Docker)

1. **Install system dependencies**:
   \`\`\`bash
   sudo apt update
   sudo apt install python3-pip python3-venv
   \`\`\`

2. **Install SQL Server ODBC Driver**:
   \`\`\`bash
   curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
   curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
   sudo apt update
   sudo ACCEPT_EULA=Y apt install msodbcsql18 unixodbc-dev
   \`\`\`

3. **Create virtual environment**:
   \`\`\`bash
   python3 -m venv venv
   source venv/bin/activate
   \`\`\`

4. **Install Python dependencies**:
   \`\`\`bash
   pip install -r requirements.txt
   \`\`\`

5. **Configure database** (update .env file with your SQL Server details)

6. **Run migrations**:
   \`\`\`bash
   python manage.py migrate
   python manage.py createsuperuser
   \`\`\`

7. **Start development server**:
   \`\`\`bash
   python manage.py runserver
   \`\`\`

## Admin Panel Features

The Django admin panel provides comprehensive management capabilities:

### Car Management
- Add/edit/delete cars with detailed specifications
- Upload multiple images per car
- Set featured cars for homepage display
- Manage car status (Available, Sold, Reserved)

### Brand Management
- Create and manage car brands
- Upload brand logos
- Add brand descriptions

### Category Management
- Organize cars into categories
- Manage category descriptions

### Inquiry Management
- View customer inquiries
- Mark inquiries as read/unread
- Filter inquiries by date and status

### Admin Customizations
- Custom list displays with thumbnails
- Advanced filtering options
- Bulk actions for status updates
- Responsive admin interface

## Database Schema

### Main Models
- **Car**: Core vehicle information with specifications
- **Brand**: Car manufacturers with logos
- **Category**: Vehicle categories (SUV, Sedan, etc.)
- **CarImage**: Multiple images per car
- **Inquiry**: Customer inquiry system

### Key Features
- Foreign key relationships between models
- Image upload handling
- Choice fields for standardized data
- Automatic timestamp tracking

## Docker Configuration

The application uses multi-container Docker setup:

- **Web Container**: Django application
- **Database Container**: SQL Server 2022 Express
- **Volumes**: Persistent data storage for database and media files

### Environment Variables
- `DEBUG`: Development mode toggle
- `DB_HOST`: Database host
- `DB_NAME`: Database name
- `DB_USER`: Database username
- `DB_PASSWORD`: Database password

## API Endpoints

- `/`: Homepage with featured cars
- `/cars/`: Car listing with filters
- `/cars/<id>/`: Car detail page
- `/brands/<id>/`: Cars by brand
- `/admin/`: Django admin panel

## Customization

### Adding New Fields
1. Update models in `cars/models.py`
2. Create and run migrations
3. Update admin interface in `cars/admin.py`
4. Modify templates as needed

### Styling
- Custom CSS in `templates/base.html`
- Bootstrap 5 components
- Font Awesome icons
- Responsive design patterns

## Production Deployment

For production deployment:

1. Set `DEBUG=False` in environment variables
2. Configure proper database credentials
3. Set up static file serving
4. Configure domain and SSL
5. Use production WSGI server (Gunicorn)

## Troubleshooting

### Common Issues

1. **Database Connection**: Ensure SQL Server is running and credentials are correct
2. **ODBC Driver**: Install Microsoft ODBC Driver 18 for SQL Server
3. **Permissions**: Check file permissions for media uploads
4. **Docker**: Ensure Docker daemon is running

### Logs
\`\`\`bash
# View application logs
docker-compose logs web

# View database logs
docker-compose logs sqlserver
\`\`\`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.
