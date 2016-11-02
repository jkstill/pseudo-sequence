
<h3>Pseudo Sequence Demo</h3>

This is a demonstration of a pseudo sequence.

That is, a single row table used to simulate an oracle sequence.

Using a table in this manner represents a serious serialization.

What was found was that row-lock contention was prevalent when run on 2 nodes of RAC.
Even when 1 node is used row-lock contention is obvious.

You can use these scripts to monitor waits:
<a href="https://github.com/jkstill/oracle-script-lib/blob/master/sesswait.sql">sesswait.sql</a>
<a href="https://github.com/jkstill/oracle-script-lib/blob/master/sesswaitu.sql">sesswaitu.sql</a>

If you are familiar with this and looking at these files, you should not require much explanation

table.sql: create the test table

package.sql: create the package
  it will be necessary to first grant EXECUTE ON DBMS_LOCK to the package owner
  100 iterations of a simulated transaction will be run

run.sh: this script runs the package 

multi-single-node.sh: starts run.sh 10 times in single node

multi-two-nodes.sh: starts run.sh 10 times, 5 times in each of two nodes


<h3>Row Lock contention on 2 Nodes</h3>

Note: sesswaitu.sql modified for RAC

Also notice the GC waits on 2 nodes.

<blockquote style='border: 2px solid #000;background-color:#D8D8D8;color:#0B0B61; white-space: pre-wrap;'>
<pre><code><i>

17:22:43 ora12c102rac01.jks.com - jkstill@js122a1 SQL> @s

                                                                                                                                                  WAIT
                                                                                                                                                  TIME
   INST_ID USERNAME   EVENT                             SID P1TEXT               P1 P2TEXT                 P2     SEQ STATE                      MICRO STATE
---------- ---------- ------------------------------ ------ ---------- ------------ ------------ ------------ ------- ---------------- --------------- ----------------
         1 JKSTILL    enq: TX - row lock contention      40 name|mode    1415053318 usn<<16 | sl       917535     666 WAITING                   24,787 WAITING
                                                                                    ot

         1                                               74 name|mode    1415053318 usn<<16 | sl      1245194     551 WAITING                   97,601 WAITING
                                                                                    ot

         2                                               50 name|mode    1415053318 usn<<16 | sl       917535     639 WAITING                   24,472 WAITING
                                                                                    ot

         1                                               89 name|mode    1415053318 usn<<16 | sl      1245194     711 WAITING                   97,680 WAITING
                                                                                    ot

         1                                               91 name|mode    1415053318 usn<<16 | sl      1245194     713 WAITING                   97,793 WAITING
                                                                                    ot

         2            gc buffer busy release             99 file#                10 block#                151     699 WAITING                   22,688 WAITING
         1            gc current request                 44 file#                10 block#                151     640 WAITING                   21,757 WAITING
         2            PL/SQL lock timer                  98 duration              0                         0     594 WAITING                   74,117 WAITING
         2                                               77 duration              0                         0     599 WAITING                   23,930 WAITING
         2                                               73 duration              0                         0     694 WAITING                   23,178 WAITING
         1            PX Deq: Execution Msg              42 sleeptime/    268566527 passes                  1       2 WAITED SHORT TIM           1,035 WAITED SHORT TIM
                                                            senderid                                                  E                                E

         2                                               92 sleeptime/    268566527 passes                  2      14 WAITED SHORT TIM               0 WAITED SHORT TIM
                                                            senderid                                                  E                                E

         1            PX Deq: Parse Reply                76 sleeptime/            0 passes                  0    6665 WAITED SHORT TIM               1 WAITED SHORT TIM
                                                            senderid                                                  E                                E


         2 SYS        class slave wait                   88 slave id              0                         0       8 WAITING                5,183,535 WAITING
         2                                               69 slave id              0                         0       5 WAITING                5,156,172 WAITING


15 rows selected.

</i></code></pre>
</blockquote>


<h3>Row Lock contention on 1 Node</h3>

<blockquote style='border: 2px solid #000;background-color:#D8D8D8;color:#0B0B61; white-space: pre-wrap;'>
<pre><code><i>

17:19:27 ora12c102rac01.jks.com - jkstill@js122a1 SQL> @s
                                                                                                                                                  WAIT
                                                                                                                                                  TIME
   INST_ID USERNAME   EVENT                             SID P1TEXT               P1 P2TEXT                 P2     SEQ STATE                      MICRO STATE
---------- ---------- ------------------------------ ------ ---------- ------------ ------------ ------------ ------- ---------------- --------------- ----------------
         1 JKSTILL    enq: TX - row lock contention      42 name|mode    1415053318 usn<<16 | sl       393229     690 WAITING                   15,828 WAITING
                                                                                    ot

         1                                               94 name|mode    1415053318 usn<<16 | sl       393229     695 WAITING                   16,189 WAITING
                                                                                    ot

         1                                               92 name|mode    1415053318 usn<<16 | sl       393229     684 WAITING                   16,089 WAITING
                                                                                    ot

         1                                               91 name|mode    1415053318 usn<<16 | sl       393229     689 WAITING                   15,947 WAITING
                                                                                    ot

         1                                               89 name|mode    1415053318 usn<<16 | sl       393229     690 WAITING                   16,027 WAITING
                                                                                    ot

         1                                               78 name|mode    1415053318 usn<<16 | sl       393229     694 WAITING                   15,890 WAITING
                                                                                    ot

         1                                               44 name|mode    1415053318 usn<<16 | sl       393229     686 WAITING                   16,244 WAITING
                                                                                    ot

         1            PL/SQL lock timer                  93 duration              0                         0     704 WAITING                   65,849 WAITING
         1                                               74 duration              0                         0     708 WAITING                   16,394 WAITING
         1                                               40 duration              0                         0     696 WAITING                   16,546 WAITING
         2            PX Deq: Execution Msg              94 sleeptime/    268566527 passes                  2      14 WAITED SHORT TIM               0 WAITED SHORT TIM
                                                            senderid                                                  E                                E

         1                                               68 sleeptime/    268566527 passes                  1       2 WAITED SHORT TIM             774 WAITED SHORT TIM
                                                            senderid                                                  E                                E

         1            PX Deq: Parse Reply                88 sleeptime/          200 passes                  2    1484 WAITED SHORT TIM               0 WAITED SHORT TIM
                                                            senderid                                                  E                                E


         2 SYS        class slave wait                   95 slave id              0                         0      25 WAITING                8,930,268 WAITING
         2                                              102 slave id              0                         0      28 WAITING                8,930,221 WAITING


15 rows selected.

</i></code></pre>
</blockquote>


