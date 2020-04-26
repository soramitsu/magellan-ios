@Library('jenkins-library@feature/magellan-ios' ) _

def appPipline = new org.ios.AppPipeline(steps: this, appRootDir: 'Example', appTagDeployment: false, libEnable: true, libAllowWarnings:true)
appPipline.runPipeline('magellan')