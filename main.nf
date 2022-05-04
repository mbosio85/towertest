#!/usr/bin/env nextflow
 
params.ntasks = 20
howMany = Channel.from( 1   ..params.ntasks )
/*
 * A Python script task which parses the output of the previous script
 */
process pyTask {
    echo true 
    container 'quay.io/biocontainers/python:3.8.3'
    cpus 1
    memory  '1 GB'
    time '1h'
    
    input: 
        val x from howMany
    
    '''
    #!/usr/local/bin/python
    import sys
    import random
    import time
    import string
    threshold = 1.0/10000
    mean_seconds = 20
    #Put some randomness in the duration of each task and avoid black swans
    random_duration = max(1,round(random.gauss(mean_seconds,10)))
    for x in range(1,random_duration):
        n = random.random()
        if n < threshold:
            raise ValueError('Random error because of value lower than threshold')
        else:
            length = 256
            letters = string.ascii_lowercase
            result_str = ''.join(random.choice(letters) for i in range(length))
            print("Random string of length", length, "is:", result_str)
            time.sleep(1)
    '''
}
