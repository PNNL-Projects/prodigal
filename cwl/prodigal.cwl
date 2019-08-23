#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: hurwitzlab/prodigal:2.6.3
baseCommand: prodigal
inputs:
  input_file:
    type: File
    inputBinding:
      position: 1
      prefix: -i
outputs:
  prodigal_out:
    type: stdout
stdout: output.txt
