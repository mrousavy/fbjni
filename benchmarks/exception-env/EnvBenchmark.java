package org.fbjni.bench;

import com.facebook.soloader.nativeloader.NativeLoader;
import com.facebook.soloader.nativeloader.SystemDelegate;

public final class EnvBenchmark {
  private double bias = 0.5;

  public double add(double a, double b) {
    return a + b + bias;
  }

  private native long measure(int scenario, int iterations);

  public static void main(String[] args) {
    NativeLoader.init(new SystemDelegate());
    NativeLoader.loadLibrary("fbjni");
    NativeLoader.loadLibrary("env-bench");
    EnvBenchmark benchmark = new EnvBenchmark();
    final int iterations = Integer.parseInt(args[1]);
    final int samples = Integer.parseInt(args[2]);
    for (int warmup = 0; warmup < 5; warmup++) {
      benchmark.measure(0, iterations);
      benchmark.measure(1, iterations);
    }
    for (int sample = 0; sample < samples; sample++) {
      for (int position = 0; position < 2; position++) {
        int scenario = (sample + position) % 2;
        long nanos = benchmark.measure(scenario, iterations);
        System.out.println("SAMPLE," + args[0] + "," + sample + "," +
            scenario + "," + iterations + "," + nanos);
      }
    }
  }
}
