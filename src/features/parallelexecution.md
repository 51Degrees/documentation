@page Features_ParallelExecution Parallel Execution

# Introduction

**Parallel execution** can refer to two or more @flowelements whose processing is executed
simultaneously within the @Pipeline.

It also refers to the ability of an individual @flowelement instance to process multiple 
requests simultaneously. E.g. One @pipeline instance with one @flowelement being called 
from separate threads.


Note, that some languages with @Pipeline implementations do not have the built-in 
ability to handle **parallel execution**. For example, the PHP process runs in a 
single-thread, so @flowelements cannot be configured to run in **parallel**.

# Executing Flow Elements in Parallel

By default, @flowelements are executed sequentially in the order
they are added to the @Pipeline. However, if the [language supports it](@ref Info_FeatureMatrix), 
two or more @flowelements can be executed in **parallel** within the overall sequential structure.

@dotfile pipeline-parallel-process.gvdot

In the example above, elements **E1** and **E2** will start their processing at the same time. 

Note that **parallel execution** is limited by the hardware the @Pipeline is running on. 
If the CPU only has two cores, then running four elements in parallel is unlikely to 
prove effective.


# Calling the Pipeline from Multiple Threads

The @Pipeline is able to handle concurrent process requests. However, the ability of a @flowelement
to also support this will depend on its individual implementation.

All 51Degrees @flowelements have been designed to function correctly in this scenario. 
(Assuming the [language supports it](@ref Info_FeatureMatrix).)
If you are writing a @customelement and want to ensure it will work in multi-threaded scenarios
then see the [custom element parallel example](@ref Examples_CustomElement_Parallel).

