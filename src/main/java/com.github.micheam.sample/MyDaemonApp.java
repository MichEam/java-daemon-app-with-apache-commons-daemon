package com.github.micheam.sample;

import org.apache.commons.daemon.Daemon;
import org.apache.commons.daemon.DaemonContext;
import org.apache.commons.daemon.DaemonInitException;

public class MyDaemonApp implements Daemon {

    private Thread thread;
    private boolean stopped = false;

    @Override
    public void init(DaemonContext context) throws DaemonInitException, Exception {
        System.out.println("init() has called.");

        this.thread = new Thread() {

            private long i = 0;

            @Override
            public void run() {
                while (!stopped) {
                    System.out.println(i++);
                    try {
                        sleep(1000);
                    } catch (InterruptedException exp) {
                        System.out.println(exp.getMessage());
                        exp.printStackTrace();
                    }
                }
            }
        };
    }

    @Override
    public void start() throws Exception {
        System.out.println("start() has called.");
        this.thread.start();
    }

    @Override
    public void stop() throws Exception {
        System.out.println("stop() has called.");
        this.stopped = true;

        try {
            thread.join();
        } catch (InterruptedException exp) {
            System.out.println(exp.getMessage());
            throw exp;
        }
    }

    @Override
    public void destroy() {
        System.out.println("destroy() has called.");
        this.thread = null;
    }
}
