import jenkins.model.Jenkins
import com.nirima.jenkins.plugins.docker.DockerCloud
import com.nirima.jenkins.plugins.docker.DockerTemplate
import com.nirima.jenkins.plugins.docker.DockerTemplateBase
import com.nirima.jenkins.plugins.docker.DockerImagePullStrategy
import io.jenkins.docker.connector.DockerComputerAttachConnector

def jenkins = Jenkins.getInstance()

// Define templates configuration
def templatesConfig = [
    [label: 'ci-builder-python', image: 'ci-builder-python:latest'],
    [label: 'ci-builder-nodejs', image: 'ci-builder-nodejs:latest'],
    [label: 'ci-builder-ruby',   image: 'ci-builder-ruby:latest'],
    [label: 'ci-builder-java',   image: 'ci-builder-java:latest']
]

def templates = []

templatesConfig.each { cfg ->
    def templateBase = new DockerTemplateBase(cfg.image)
    templateBase.setVolumesString("/var/run/docker.sock:/var/run/docker.sock\njenkins-data:/var/jenkins_home")
    templateBase.setNetwork("home-lab")

    def template = new DockerTemplate(
        templateBase,
        new DockerComputerAttachConnector(),
        cfg.label,
        "/var/jenkins_home", // remoteFs
        "5" // instanceCapStr
    )
    template.setPullStrategy(DockerImagePullStrategy.PULL_NEVER)
    template.name = cfg.label
    templates << template
}

// Remove existing cloud named "Docker-Host" if it exists
def existingCloud = jenkins.clouds.getByName("Docker-Host")
if (existingCloud) {
    jenkins.clouds.remove(existingCloud)
    println "Removed existing Docker-Host cloud configuration"
}

// Add the new Docker Cloud
def dockerCloud = new DockerCloud(
    "Docker-Host",
    templates,
    "unix:///var/run/docker.sock",
    10, // containerCap
    10, // connectTimeout
    10, // readTimeout
    null, // credentialsId
    null, // version
    null  // dockerHostname
)

jenkins.clouds.add(dockerCloud)
jenkins.save()
println "Docker Cloud 'Docker-Host' with clean-slate templates configured successfully!"
