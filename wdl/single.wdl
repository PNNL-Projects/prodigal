workflow prodigal {
    File input_file
    String output_format

    call run {
        input:
            input_file = input_file,
            output_format = output_format
    }
}

task run {
    File input_file
    String output_format

    String input_basename = basename(input_file)

    command { 
        docker run -v $PWD:/out -v /Users:/Users -w /out \
        hurwitzlab/prodigal:2.6.3 prodigal \
        -i ${input_file} \
        -f ${output_format} \
        -o ${input_basename}.out \
        -a ${input_basename}.proteins \
        -d ${input_basename}.nucls \
        -s ${input_basename}.genes 
    }

    output {
        File out="${input_basename}.out"
        File proteins="${input_basename}.proteins"
        File nucleotides="${input_basename}.nucls"
        File genes="${input_basename}.genes"
    }
}
