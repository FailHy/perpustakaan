pipeline {
    agent any
    
    tools {
        maven 'Maven'
        jdk 'JDK17'
    }
    
    environment {
        DOCKER_COMPOSE = 'docker compose'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '📥 Cloning repository...'
                checkout scm
            }
        }
        
        stage('Build All Services') {
            parallel {
                stage('Build Anggota') {
                    steps {
                        echo '🔨 Building Anggota Service...'
                        dir('anggota') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Build Buku') {
                    steps {
                        echo '🔨 Building Buku Service...'
                        dir('buku') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Build Peminjaman') {
                    steps {
                        echo '🔨 Building Peminjaman Service...'
                        dir('peminjaman') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Build Pengembalian') {
                    steps {
                        echo '🔨 Building Pengembalian Service...'
                        dir('pengembalian') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
            }
        }
        
        stage('Test All Services') {
            parallel {
                stage('Test Anggota') {
                    steps {
                        echo '🧪 Testing Anggota Service...'
                        dir('anggota') {
                            sh 'mvn test -Dspring.profiles.active=test'
                        }
                    }
                }
                stage('Test Buku') {
                    steps {
                        echo '🧪 Testing Buku Service...'
                        dir('buku') {
                            sh 'mvn test -Dspring.profiles.active=test'
                        }
                    }
                }
                stage('Test Peminjaman') {
                    steps {
                        echo '🧪 Testing Peminjaman Service...'
                        dir('peminjaman') {
                            sh 'mvn test -Dspring.profiles.active=test'
                        }
                    }
                }
                stage('Test Pengembalian') {
                    steps {
                        echo '🧪 Testing Pengembalian Service...'
                        dir('pengembalian') {
                            sh 'mvn test -Dspring.profiles.active=test'
                        }
                    }
                }
            }
        }
        
        stage('Verify Infrastructure') {
            steps {
                echo '🐳 Checking Docker and Infrastructure...'
                sh 'docker --version'
                sh "${DOCKER_COMPOSE} version"
            }
        }
        
        // ====== PERBAIKAN DI SINI ======
        stage('Deploy Infrastructure') {
            steps {
                echo '🚀 Cleaning and Starting Infrastructure Services...'
                // Stop dan hapus semua container dari project ini
                sh "${DOCKER_COMPOSE} down --remove-orphans || true"
                // Force remove container yang mungkin konflik dari project lain
                sh 'docker rm -f rabbitmq elasticsearch logstash kibana prometheus grafana 2>/dev/null || true'
                // Mulai ulang infrastructure
                sh "${DOCKER_COMPOSE} up -d rabbitmq elasticsearch"
                echo '⏳ Waiting for infrastructure to be ready...'
                sh 'sleep 30'
            }
        }
        
        stage('Deploy ELK Stack') {
            steps {
                echo '📊 Starting ELK Stack (Logstash, Kibana)...'
                sh "${DOCKER_COMPOSE} up -d logstash kibana"
                echo '⏳ Waiting for ELK to be ready...'
                sh 'sleep 30'
            }
        }
        
        stage('Deploy Monitoring') {
            steps {
                echo '📈 Starting Prometheus & Grafana...'
                sh "${DOCKER_COMPOSE} up -d prometheus grafana"
                echo '⏳ Waiting for monitoring to be ready...'
                sh 'sleep 15'
            }
        }
        
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
                            sh "curl -s -o /dev/null -w '%{http_code}' ${svc.url}"
                            echo "✅ ${svc.name} is healthy"
                        } catch (Exception e) {
                            echo "⚠️ ${svc.name} might not be ready yet"
                        }
                    }
                }
            }
        }
        
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
                
                📊 MONITORING & LOGS:
                   • RabbitMQ UI:      http://localhost:15672
                   • Kibana:           http://localhost:5601
                   • Grafana:          http://localhost:3000
                ═══════════════════════════════════════════════════════
                '''
            }
        }
    }
    
    post {
        success {
            echo '✅ BUILD & DEPLOYMENT SUCCESSFUL!'
        }
        failure {
            echo '❌ BUILD OR DEPLOYMENT FAILED!'
        }
        always {
            echo "🔄 Pipeline completed at: ${new Date().format('yyyy-MM-dd HH:mm:ss')}"
        }
    }
}