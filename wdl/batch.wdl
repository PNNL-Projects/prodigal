workflow prodigal {
    String query
    String output_format

    call run {
        input:
            query = query,
            output_format = output_format
    }
}

task run {
    String query
    String output_format

    command { 
        docker run -v $PWD:/out -v /Users:/Users -w /out \
        hurwitzlab/prodigal:2.6.3 run_prodigal \
        -q ${query} \
        -f ${output_format} \
        -asd
    }

    #output {
    #    File out="${input_basename}.out"
    #    File proteins="${input_basename}.proteins"
    #    File nucleotides="${input_basename}.nucls"
    #    File genes="${input_basename}.genes"
    #}
}
