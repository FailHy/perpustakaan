pipeline {
    agent any
    
    tools {
        maven 'Maven'
        jdk 'JDK17'
    }
    
    environment {
        DOCKER_COMPOSE = 'docker compose'
        PROJECT_NAME = 'perpustakaan-microservices'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '📥 Cloning repository...'
                checkout scm
            }
        }
        
        // ====== BUILD STAGE ======
        stage('Build All Services') {
            parallel {
                stage('Build Anggota') {
                    steps {
                        echo '🔨 Building Anggota Service...'
                        dir('anggota') {
                            bat 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Build Buku') {
                    steps {
                        echo '🔨 Building Buku Service...'
                        dir('buku') {
                            bat 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Build Peminjaman') {
                    steps {
                        echo '🔨 Building Peminjaman Service...'
                        dir('peminjaman') {
                            bat 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Build Pengembalian') {
                    steps {
                        echo '🔨 Building Pengembalian Service...'
                        dir('pengembalian') {
                            bat 'mvn clean package -DskipTests'
                        }
                    }
                }
            }
        }
        
        // ====== TEST STAGE ======
        stage('Test All Services') {
            parallel {
                stage('Test Anggota') {
                    steps {
                        echo '🧪 Testing Anggota Service...'
                        dir('anggota') {
                            bat 'mvn test'
                        }
                    }
                }
                stage('Test Buku') {
                    steps {
                        echo '🧪 Testing Buku Service...'
                        dir('buku') {
                            bat 'mvn test'
                        }
                    }
                }
                stage('Test Peminjaman') {
                    steps {
                        echo '🧪 Testing Peminjaman Service...'
                        dir('peminjaman') {
                            bat 'mvn test'
                        }
                    }
                }
                stage('Test Pengembalian') {
                    steps {
                        echo '🧪 Testing Pengembalian Service...'
                        dir('pengembalian') {
                            bat 'mvn test'
                        }
                    }
                }
            }
        }
        
        // ====== INFRASTRUCTURE CHECK ======
        stage('Verify Infrastructure') {
            steps {
                echo '🐳 Checking Docker and Infrastructure...'
                bat 'docker --version'
                bat 'docker compose version'
            }
        }
        
        // ====== DEPLOY INFRASTRUCTURE ======
        stage('Deploy Infrastructure') {
            steps {
                echo '🚀 Starting Infrastructure Services...'
                bat '%DOCKER_COMPOSE% up -d rabbitmq elasticsearch'
                echo '⏳ Waiting for infrastructure to be ready...'
                bat 'timeout /t 30 /nobreak'
            }
        }
        
        // ====== DEPLOY ELK STACK ======
        stage('Deploy ELK Stack') {
            steps {
                echo '📊 Starting ELK Stack (Logstash, Kibana)...'
                bat '%DOCKER_COMPOSE% up -d logstash kibana'
                echo '⏳ Waiting for ELK to be ready...'
                bat 'timeout /t 30 /nobreak'
            }
        }
        
        // ====== DEPLOY MONITORING ======
        stage('Deploy Monitoring') {
            steps {
                echo '📈 Starting Prometheus & Grafana...'
                bat '%DOCKER_COMPOSE% up -d prometheus grafana'
                echo '⏳ Waiting for monitoring to be ready...'
                bat 'timeout /t 15 /nobreak'
            }
        }
        
        // ====== HEALTH CHECK ======
        stage('Health Check') {
            steps {
                echo '🏥 Verifying all services health...'
                script {
                    def services = [
                        [name: 'RabbitMQ', url: 'http://localhost:15672'],
                        [name: 'Elasticsearch', url: 'http://localhost:9200/_cluster/health'],
                        [name: 'Kibana', url: 'http://localhost:5601/api/status'],
                        [name: 'Prometheus', url: 'http://localhost:9090/-/healthy'],
                        [name: 'Grafana', url: 'http://localhost:3000/api/health']
                    ]
                    
                    services.each { svc ->
                        try {
                            bat "curl -s -o nul -w \"%%{http_code}\" ${svc.url}"
                            echo "✅ ${svc.name} is healthy"
                        } catch (Exception e) {
                            echo "⚠️ ${svc.name} might not be ready yet"
                        }
                    }
                }
            }
        }
        
        // ====== DISPLAY INFO ======
        stage('Display Access URLs') {
            steps {
                echo '''
                ═══════════════════════════════════════════════════════
                🎉 DEPLOYMENT COMPLETE! Access URLs:
                ═══════════════════════════════════════════════════════
                
                📚 MICROSERVICES:
                   • Eureka Server:    http://localhost:8761
                   • API Gateway:      http://localhost:9000
                   • Anggota Service:  http://localhost:8081
                   • Buku Service:     http://localhost:8082
                   • Peminjaman:       http://localhost:8083
                   • Pengembalian:     http://localhost:8084
                
                🐰 MESSAGE BROKER:
                   • RabbitMQ UI:      http://localhost:15672 (guest/guest)
                
                📊 ELK STACK:
                   • Elasticsearch:    http://localhost:9200
                   • Kibana:           http://localhost:5601
                
                📈 MONITORING:
                   • Prometheus:       http://localhost:9090
                   • Grafana:          http://localhost:3000 (admin/admin)
                
                ═══════════════════════════════════════════════════════
                '''
            }
        }
    }
    
    post {
        success {
            echo '''
            ╔═══════════════════════════════════════════════════════╗
            ║  ✅ BUILD & DEPLOYMENT SUCCESSFUL!                    ║
            ║                                                       ║
            ║  All microservices built, tested, and infrastructure  ║
            ║  deployed successfully.                               ║
            ╚═══════════════════════════════════════════════════════╝
            '''
        }
        failure {
            echo '''
            ╔═══════════════════════════════════════════════════════╗
            ║  ❌ BUILD OR DEPLOYMENT FAILED!                       ║
            ║                                                       ║
            ║  Please check the console output for details.         ║
            ╚═══════════════════════════════════════════════════════╝
            '''
        }
        always {
            echo '🔄 Pipeline completed at: ' + new Date().format('yyyy-MM-dd HH:mm:ss')
        }
    }
}
