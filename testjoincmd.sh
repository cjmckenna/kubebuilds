#!/bin/bash
joincommand=$(base64 joincommand.txt | tr -d \\n)

shavalue=$(curl -X GET https://api.github.com/repos/cjmckenna/kubebuilds/contents/joincommand.txt | jq .sha)

if [ -z "$shavalue" ]; then
  curl -i -X PUT -H "Authorization: token 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" -d "{\"path\": \"joincommand.txt\", \"message\": \"initial commit\", \"content\": \"${joincommand}\"}" https://api.github.com/repos/cjmckenna/kubebuilds/contents/joincommand.txt
else
  curl -i -X PUT -H "Authorization: token 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" -d "{\"path\": \"joincommand.txt\", \"message\": \"initial commit\", \"content\": \"${joincommand}\", \"sha\": $shavalue}" https://api.github.com/repos/cjmckenna/kubebuilds/contents/joincommand.txt
fi