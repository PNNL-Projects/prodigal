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
  output_file:
    type: string
    inputBinding:
      position: 1
      prefix: -o
  closed_ends:
    type: boolean
    inputBinding:
      position: 1
      prefix: -c
  ns_as_masked:
    type: boolean
    inputBinding:
      position: 1
      prefix: -m
  bypass_trainer:
    type: boolean
    inputBinding:
      position: 1
      prefix: -n
  quiet:
    type: boolean
    inputBinding:
      position: 1
      prefix: -q
  translation_table:
    type: int
    inputBinding:
      position: 1
      prefix: -g
  procedure:
    type: string
    inputBinding:
      position: 1
      prefix: -p
  output_format:
    type: string
    inputBinding:
      position: 1
      prefix: -f 
  proteins_file:
    type: string
    inputBinding:
      position: 1
      prefix: -a 
  nucs_file:
    type: string
    inputBinding:
      position: 1
      prefix: -d 
  genes_file:
    type: string
    inputBinding:
      position: 1
      prefix: -s 
outputs:
  prodigal_stdout:
    type: stdout
  prodigal_stderr:
    type: stderr
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_file)
  proteins:
    type: File
    outputBinding:
      glob: $(inputs.proteins_file)
  nucleotides:
    type: File
    outputBinding:
      glob: $(inputs.nucs_file)
  genes:
    type: File
    outputBinding:
      glob: $(inputs.genes_file)
stdout: stdout.txt
stderr: stderr.txt
