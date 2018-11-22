properties(\
	[buildDiscarder(\
		logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '100')), \
		parameters([\
		choice(name: 'BROWSER_FOR_ROBOT', choices: "chrome\nfirefox",  description: 'Which browser to use?')]), \
		pipelineTriggers([])])

timestamps {
	timeout(60) {
		stage('Build') {
			branch = "${env.BRANCH_NAME}"
			build = "${env.BUILD_NUMBER}"

			repoOwner = "jyri.ilama@siili.com"

			node('azure-ubuntu-1') {
				try {
					cutWs = "${WORKSPACE}".split('/')[-1]
					shortWs  = "${WORKSPACE}" - cutWs
					ws("${shortWs}/${JOB_NAME}") {
						checkoutAndReadGitInfo()
						sh """
						./env_setup.sh ${params.BROWSER_FOR_ROBOT}
						Xvfb :89 -ac &
						export DISPLAY=:89
						./run.sh "--variable BROWSER:${params.BROWSER_FOR_ROBOT}"||true"""
						if (fileExists('output/output.xml')) {
							publishRobotResults("output", "output.xml", "log.html", "report.html", true)
						} else {
							def warningText = "WARNING: No test results available - were the tests executed?"
							echo warningText
							writeToDescription(warningText, "red")
							currentBuild.result = "UNSTABLE"
						}
					}
				} catch (e) {
					//emailext body: '$DEFAULT_CONTENT', subject: "${repoName} Build FAILED in ${branch}", to: "${author}, cc: ${repoOwner}"
					error "${e}"
				}
			}
		}
	}
}
 
def checkoutAndReadGitInfo() {
	retry(2) {
		checkout scm
		def gitCommands = """
		git clean -xdf
		git rev-parse HEAD > GIT_COMMIT
		git log -n1|grep Author|sed 's/.* //g'|sed "s/[<>]//g">AUTHOR
		"""
		if (isUnix()) {
			sh """#!/bin/bash
			${gitCommands}
			basename `git remote show -n origin | grep Fetch | cut -d: -f2-` .git>REPO_NAME"""
		} else {
			bat """@echo off
			${gitCommands}
			git remote show -n origin | grep Fetch | cut -d: -f2- >REPO_URL
			set /p REPO_URL=<REPO_URL
			basename %REPO_URL% .git>REPO_NAME
			"""
		}
	}

	author = readOneliner("AUTHOR")
	commit = readOneliner("GIT_COMMIT")
	repoName = readOneliner("REPO_NAME")
	echo "author: ${author}, commit: ${commit}, repository: ${repoName}"
	writeFile file: "build_info.txt", text: "commit: ${commit}\nauthor: ${author}\nrepository: ${repoName}\nbranch: ${branch}\nbuild: ${build}"
}

def runTests(filePath, extraArgs) {
	def robotCommand = "robot ${extraArgs} ${filePath}||true"
        if (isUnix()) sh "${robotCommand}"
        else bat "${robotCommand}"
}

def publishRobotResults(outputFolder, robotOutput, robotLog, robotReport, fastFail) {
	step([$class: 'RobotPublisher', unstableThreshold: 0, passThreshold: 100, outputPath: outputFolder, logFileName: robotLog, onlyCritical: true, otherFiles: "**/*", outputFileName: robotOutput, reportFileName: robotReport, enableCache: false])
	if (currentBuild.result == "UNSTABLE") archiveArtifacts "${outputFolder}/${robotOutput}"
}

def createPackageAndArchive(zipName, inputPath) {
	def zipCommand = "zip -qo ${zipName} ${inputPath}"
	if (isUnix()) {
		sh "${zipCommand}"
	} else {
		bat "${zipCommand}"
	}
	archiveArtifacts zipName

}

def writeToDescription(newDescription, color="black") {
	if (currentBuild.description == null) {
		currentBuild.description = "<li style=\"color:${color}\">${newDescription}"
	} else {
		currentBuild.description += "<li style=\"color:${color}\">${newDescription}"
	}
}

def readOneliner(fileName) {
	def matcher = readFile(fileName) =~ '([a-zA-Z0-9-.@/]+)'
	matcher ? matcher[0][1] : null
}
