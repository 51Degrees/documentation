@page Features_ParallelExecution Parallel Execution

# Introduction

**Parallel execution** can refer to two or more @flowelements that execute their 
processing step simultaneously within the Pipeline.

It can also refer to the ability of an individual @flowelement instance to process multiple 
requests simultaneously (E.g. One pipeline instance with one @flowelement that is called  
from separate threads).

Note that some languages with Pipeline implementations do not have any built-in 
ability to handle **parallel execution**. For example, the PHP process runs in a 
single-thread as so @flowelements cannot be configured to run in **parallel**.

# Executing flow elements in parallel

By default, @flowelements are executed sequentially in the order
they are added to the @Pipeline. However, if the [language supports](@ref Info_FeatureMatrix) it, 
two or more @flowelements can also be executed in **parallel** within the overall sequential structure.

@dotfile pipeline-parallel-process.gvdot

In the example above, elements **E1** and **E2** will start their processing at the same time. 

Note that **parallel execution** is limited by the hardware of the system the @Pipeline is 
running on. If the CPU only has two cores then running four elements in parallel is not going to 
be very effective.


# Calling the Pipeline from multiple threads

The @Pipeline is able to handle concurrent process requests. However, there is no guarantee 
that all @flowelements will be able to. This is dependent on the individual implementations
of those @flowelements.

However, all 51Degrees @flowelements have been designed to function correctly in this scenario. 
(assuming the language supports it)


