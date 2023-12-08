pipeline{
    agent { label 'JDK-17' }
    triggers{
        pollSCM('* * * * *')
    }
    stages{
        stage( 'VCS'){
            steps{
                git url: 'https://github.com/Gopi0527/nopCommerce.git',
                branch: 'dev'
            }
        }
        stage( 'Build the dotnet'){
            steps{
                sh 'dotnet tool install --global dotnet-sonarscanner
dotnet sonarscanner begin k:spring-petclinic-gopi_cli o:spring-petclinic-gopi d:sonar.token=SONAR_CLOUD
dotnet build -c Release src/NopCommerce.sln
dotnet sonarscanner end'
            }
            post{
                success{
                    sh 'mkdir ./published/bin ./published/logs'
                    sh 'tar -czvf nop.web.tar.gz ./published/'
                    archiveArtifacts  artifacts: '**/*.tar.gz'
                } 
                failure{
                    mail subject: 'build stage failure',
                         to: 'krishna@qt.com',
                         from: 'krishna@qt.com',
                         body:  "Refer to $BUILD_URL for more details"
                }
                
            }
        }


    }
}