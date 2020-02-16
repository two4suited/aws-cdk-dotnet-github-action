#!/bin/bash

set -u

function parseInputs(){
	# Required inputs
	if [ "${INPUT_CDK_SUBCOMMAND}" == "" ]; then
		echo "Input cdk_subcommand cannot be empty"
		exit 1
	fi
}

function installAwsCdk(){
	echo "Install aws-cdk ${INPUT_CDK_VERSION}"
	if [ "${INPUT_CDK_VERSION}" == "latest" ]; then
		npm install -g aws-cdk >/dev/null 2>&1
		if [ "${?}" -ne 0 ]; then
			echo "Failed to install aws-cdk ${INPUT_CDK_VERSION}"
		else
			echo "Successful install aws-cdk ${INPUT_CDK_VERSION}"
		fi
	else
		npm install -g aws-cdk@${INPUT_CDK_VERSION} >/dev/null 2>&1
		if [ "${?}" -ne 0 ]; then
			echo "Failed to install aws-cdk ${INPUT_CDK_VERSION}"
		else
			echo "Successful install aws-cdk ${INPUT_CDK_VERSION}"
		fi
	fi
}


function runCdk(){
	
	approvalarg=""
	if [ "${INPUT_CDK_REQUIREAPPROVAL}" == "never" ]; then
		approvalarg = "--require-approval=never"
	fi

	echo "Run cdk ${INPUT_CDK_SUBCOMMAND} ${approvalarg} ${*} \"${INPUT_CDK_STACK}\""
	output=$(cdk ${INPUT_CDK_SUBCOMMAND} ${*} "${INPUT_CDK_STACK}" 2>&1)
	exitCode=${?}
	echo ::set-output name=status_code::${exitCode}
	echo "${output}"

	commentStatus="Failed"
	if [ "${exitCode}" == "0" -o "${exitCode}" == "1" ]; then
		commentStatus="Success"
	else
		exit 1
	fi

}

function main(){
	parseInputs
	cd ${GITHUB_WORKSPACE}/${INPUT_WORKING_DIR}
	installAwsCdk
	runCdk
}

main