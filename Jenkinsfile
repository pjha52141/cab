pipeline {
    agent any

    environment {
        SONAR_SCANNER = tool name: 'SonarScanner for MSBuild'
        PATH = "${SONAR_SCANNER}:${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Test-asdc/cab-devsecops.git'
            }
        }

        stage('Fix Solution File') {
            steps {
                sh '''
                    echo "Removing missing project reference from solution (if exists)..."
                    dotnet sln CAB.sln remove TestProject/TestProject.csproj || true
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'jenkins-token', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv('sonar-server') {
                        sh '''
                            dotnet ${SONAR_SCANNER}/SonarScanner.MSBuild.dll begin /k:"cab-devsecops" /d:sonar.login=$SONAR_TOKEN /d:sonar.verbose=true
                            dotnet build CAB.sln
                            dotnet ${SONAR_SCANNER}/SonarScanner.MSBuild.dll end /d:sonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }
    }
}
