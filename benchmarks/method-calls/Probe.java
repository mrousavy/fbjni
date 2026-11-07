package bench;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Random;

public final class Probe {
  public static class Target {
    public int value;
    public final Object tag;

    public Target(int value, Object tag) {
      this.value = value;
      this.tag = tag;
    }

    public int zero() { return 37; }
    public int four(int a, int b, int c, int d) { return a + b + c + d; }
    public double add(double a, double b) { return a + b; }
    public void set(int i) { value = i; }
    public Object identity(Object o) { return o; }
    public static int length(String value) { return value.length(); }

    public static long mixed(boolean yes, byte b, char c, short s, int i,
        long l, float f, double d, Object o) {
      return (yes ? 10 : 0) + b + c + s + i + l + (long)(f * 4) +
          (long)(d * 2) + (o == null ? 0 : 5);
    }
  }

  public static final class Child extends Target {
    public Child() { super(0, null); }
    @Override public int zero() { return 41; }
    @Override public double add(double a, double b) { return a - b; }
  }

  private static final String[] CASES = {
    "virtual_zero", "virtual_four_ints", "static_mixed", "nonvirtual_doubles",
    "virtual_void", "virtual_object", "constructor", "static_string_conversion",
    "raw_a_four_ints_control"
  };
  private static native long sample(Target target, Class<Target> type,
      int which, int iterations);

  public static void main(String[] args) {
    System.loadLibrary("call-bench");
    long seed = Long.parseLong(args[0]);
    int rounds = Integer.parseInt(args[1]);
    int iterations = Integer.parseInt(args[2]);
    Target target = new Child();
    List<Integer> order = new ArrayList<>();
    for (int i = 0; i < CASES.length; ++i) order.add(i);
    Random random = new Random(seed);

    for (int round = -3; round < rounds; ++round) {
      Collections.shuffle(order, random);
      for (int which : order) {
        int count = which == 6 || which == 7 ? iterations / 4 : iterations;
        int n = round < 0 ? count / 2 : count;
        long elapsed = sample(target, Target.class, which, n);
        if (round >= 0) {
          System.out.printf(Locale.ROOT,
              "{\"case\":\"%s\",\"round\":%d,\"iterations\":%d,\"elapsed_ns\":%d}%n",
              CASES[which], round, n, elapsed);
        }
      }
    }
  }
}
