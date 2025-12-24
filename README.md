# Microservice Perpustakaan - Library Management System

## Overview

Sistem manajemen perpustakaan berbasis microservice architecture dengan Spring Boot yang mengimplementasikan 6 teknologi modern untuk tugas kuliah.

---

## 🏗️ Arsitektur Microservices

```
├── anggota/          # Member Service (Port 8081)
├── buku/             # Book Service (Port 8082)
├── peminjaman/       # Borrowing Service (Port 8083) - CQRS
├── pengembalian/     # Return Service (Port 8084)
└── Jenkinsfile       # CI/CD Pipeline
```

---

## 🚀 Teknologi yang Diimplementasikan

| # | Teknologi | Deskripsi |
|---|-----------|-----------|
| 1 | **CQRS** | Command Query Responsibility Segregation pada service Peminjaman |
| 2 | **RabbitMQ** | Event-driven messaging untuk email notification |
| 3 | **Structured Logging** | ELK-ready JSON logging dengan correlation-id |
| 4 | **Distributed Tracing** | Micrometer Tracing dengan traceId/spanId |
| 5 | **Actuator Monitoring** | Health checks & metrics endpoints |
| 6 | **Jenkins CI** | Automated build & test pipeline |

---

## 📋 Prerequisites

- Java 17
- Maven 3.6+
- RabbitMQ Server (untuk event messaging)
- Git
- Jenkins (untuk CI/CD)

---

## 🔧 Setup & Installation

### 1. Clone Repository
```bash
git clone https://github.com/FailHy/perpustakaan.git
cd perpustakaan
```

### 2. Start RabbitMQ
```bash
docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3-management-alpine
```

### 3. Build All Services
```bash
# Build semua service
cd anggota && mvn clean package && cd ..
cd buku && mvn clean package && cd ..
cd peminjaman && mvn clean package && cd ..
cd pengembalian && mvn clean package && cd ..
```

### 4. Run Services
```bash
# Terminal 1 - Anggota
cd anggota && mvn spring-boot:run

# Terminal 2 - Buku
cd buku && mvn spring-boot:run

# Terminal 3 - Peminjaman
cd peminjaman && mvn spring-boot:run

# Terminal 4 - Pengembalian
cd pengembalian && mvn spring-boot:run
```

---

## 🧪 Testing

### REST API Endpoints

**Anggota Service (8081):**
```bash
GET    http://localhost:8081/api/anggota
POST   http://localhost:8081/api/anggota
GET    http://localhost:8081/api/anggota/{id}
PUT    http://localhost:8081/api/anggota/{id}
DELETE http://localhost:8081/api/anggota/{id}
```

**Buku Service (8082):**
```bash
GET    http://localhost:8082/api/buku
POST   http://localhost:8082/api/buku
GET    http://localhost:8082/api/buku/{id}
PUT    http://localhost:8082/api/buku/{id}
DELETE http://localhost:8082/api/buku/{id}
```

**Peminjaman Service (8083) - CQRS:**
```bash
# Commands
POST   http://localhost:8083/api/peminjaman
PUT    http://localhost:8083/api/peminjaman/{id}
DELETE http://localhost:8083/api/peminjaman/{id}

# Queries
GET    http://localhost:8083/api/peminjaman
GET    http://localhost:8083/api/peminjaman/anggota/{id}
GET    http://localhost:8083/api/peminjaman/buku/{id}
```

**Pengembalian Service (8084):**
```bash
GET    http://localhost:8084/api/pengembalian
POST   http://localhost:8084/api/pengembalian/proses
GET    http://localhost:8084/api/pengembalian/{id}
```

### Actuator Endpoints

```bash
# Health Check
curl http://localhost:8081/actuator/health

# Metrics
curl http://localhost:8081/actuator/metrics

# HTTP Request Stats
curl http://localhost:8081/actuator/metrics/http.server.requests
```

---

## 🔍 Monitoring & Observability

### 1. Structured Logging
Setiap request akan di-log dengan format:
```
01:43:15.123 INFO [traceId,spanId] c.p.a.controller - Request received action=GET_ALL status=SUCCESS
```

### 2. Distributed Tracing
traceId yang sama akan muncul di semua service yang terlibat dalam satu request flow.

### 3. Health Monitoring
Akses `/actuator/health` untuk cek status service real-time.

---

## 🔄 Jenkins CI/CD

### Setup Jenkins Pipeline

1. **Install Jenkins**
   ```bash
   java -jar jenkins.war --httpPort=8080
   ```

2. **Create Pipeline Job**
   - Name: `Perpustakaan-Microservices`
   - Type: Pipeline
   - SCM: Git
   - Repository: `https://github.com/FailHy/perpustakaan.git`
   - Script Path: `Jenkinsfile`

3. **Configure Tools**
   - Maven 3.9.x
   - JDK 17

4. **Build**
   - Click "Build Now"
   - Pipeline akan otomatis build & test semua service

Lihat `jenkins_ci_guide.md` untuk panduan detail.

---

## 📊 CQRS Implementation

Service **Peminjaman** menggunakan CQRS pattern:

**Commands (Write):**
- `CreatePeminjamanCommand`
- `UpdatePeminjamanCommand`
- `DeletePeminjamanCommand`

**Queries (Read):**
- `GetAllPeminjamanQuery`
- `GetPeminjamanByIdQuery`
- `GetPeminjamanWithDetailsQuery`

---

## 📨 RabbitMQ Event Flow

```
POST /api/peminjaman
    ↓
CreatePeminjamanHandler
    ↓ Publish Event
RabbitMQ (library_exchange)
    ↓ Consume
RabbitMQConsumerService
    ↓
EmailService → Send notification
```

---

## 📁 Project Structure

```
perpustakaan/
├── anggota/
│   ├── src/main/java/com/pail/anggota/
│   │   ├── controller/
│   │   ├── service/
│   │   ├── model/
│   │   └── repository/
│   └── pom.xml
├── buku/
│   └── ... (same structure)
├── peminjaman/
│   ├── src/main/java/com/pail/peminjaman/
│   │   ├── application/
│   │   │   ├── commands/
│   │   │   └── queries/
│   │   ├── controller/
│   │   └── service/
│   └── pom.xml
├── pengembalian/
│   └── ... (same structure)
└── Jenkinsfile
```

---

## 🎯 Key Features

- ✅ Microservice Architecture
- ✅ CQRS Pattern (Peminjaman Service)
- ✅ Event-Driven (RabbitMQ)
- ✅ Distributed Tracing
- ✅ Structured Logging
- ✅ Health Monitoring
- ✅ Automated CI/CD

---

## 📝 License

This project is for educational purposes (Tugas Kuliah).

---

## 👥 Author

**Date:** 25 Desember 2024  
**Status:** ✅ Production Ready
