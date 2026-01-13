# Microservice Perpustakaan

Sistem manajemen perpustakaan berbasis microservice architecture dengan Spring Boot.

---

## Arsitektur

- **anggota** (Port 8081) - Member Service
- **buku** (Port 8082) - Book Service  
- **peminjaman** (Port 8083) - Borrowing Service (with CQRS)
- **pengembalian** (Port 8084) - Return Service

---

## Teknologi yang Diterapkan

1. **CQRS (Command Query Responsibility Segregation)**
2. **RabbitMQ Event-Driven Architecture**
3. **Structured Logging (Logstash-ready JSON)**
4. **ELK Stack (Elasticsearch, Logstash, Kibana)**
5. **Distributed Tracing (Micrometer)**
6. **Prometheus & Grafana Monitoring**
7. **Spring Boot Actuator**
8. **Jenkins CI/CD**

## Prerequisites

- Java 17
- Maven 3.6+
- Docker & Docker Compose
- (Optional) Jenkins untuk CI/CD

---

## Quick Start

### Option 1: Docker Compose (Recommended)

```bash
# Start all infrastructure (RabbitMQ, ELK, Prometheus, Grafana)
docker-compose up -d

# Access Services
# - RabbitMQ UI: http://localhost:15672 (guest/guest)
# - Kibana: http://localhost:5601
# - Prometheus: http://localhost:9090
# - Grafana: http://localhost:3000 (admin/admin)
```

### Option 2: Local Development

```bash
# Run each service
cd anggota && mvn spring-boot:run
cd buku && mvn spring-boot:run
cd peminjaman && mvn spring-boot:run
cd pengembalian && mvn spring-boot:run
```

---

## Documentation

- **Technology Guide**: Penjelasan detail setiap teknologi yang diterapkan
- **Jenkinsfile**: CI/CD pipeline configuration

---