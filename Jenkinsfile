pipeline {
    agent any
    
    tools {
        maven 'Maven'
        jdk 'JDK17'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }
        
        stage('Build Anggota Service') {
            steps {
                echo 'Building Anggota Service...'
                dir('anggota') {
                    bat 'mvn clean package -DskipTests'
                }
            }
        }
        
        stage('Test Anggota Service') {
            steps {
                echo 'Testing Anggota Service...'
                dir('anggota') {
                    bat 'mvn test'
                }
            }
        }
        
        stage('Build Buku Service') {
            steps {
                echo 'Building Buku Service...'
                dir('buku') {
                    bat 'mvn clean package -DskipTests'
                }
            }
        }
        
        stage('Test Buku Service') {
            steps {
                echo 'Testing Buku Service...'
                dir('buku') {
                    bat 'mvn test'
                }
            }
        }
        
        stage('Build Peminjaman Service') {
            steps {
                echo 'Building Peminjaman Service...'
                dir('peminjaman') {
                    bat 'mvn clean package -DskipTests'
                }
            }
        }
        
        stage('Test Peminjaman Service') {
            steps {
                echo 'Testing Peminjaman Service...'
                dir('peminjaman') {
                    bat 'mvn test'
                }
            }
        }
        
        stage('Build Pengembalian Service') {
            steps {
                echo 'Building Pengembalian Service...'
                dir('pengembalian') {
                    bat 'mvn clean package -DskipTests'
                }
            }
        }
        
        stage('Test Pengembalian Service') {
            steps {
                echo 'Testing Pengembalian Service...'
                dir('pengembalian') {
                    bat 'mvn test'
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ All services built and tested successfully!'
        }
        failure {
            echo '❌ Build or test failed!'
        }
        always {
            echo 'Pipeline completed.'
        }
    }
}
