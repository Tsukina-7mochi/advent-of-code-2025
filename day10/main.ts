import { TextLineStream } from "@std/streams";

type Machine = {
  indicator: number;
  buttons: number[];
  buttonsRaw: number[][];
  joltages: number[];
};

function vecEq(a: number[], b: number[]): boolean {
  if (a.length !== b.length) return false;
  for (let i = 0; i < a.length; i++) {
    if (a[i] !== b[i]) return false;
  }
  return true;
}

function vecSub(a: number[], b: number[]): number[] {
  return a.map((v, i) => v - b[i]);
}

function vecMul(a: number[], b: number[]): number[] {
  return a.map((v, i) => v * b[i]);
}

function vecScale(v: number[], s: number): number[] {
  return v.map((v) => v * s);
}

function parseIndicator(text: string): number {
  return [...text].slice(1, -1).reduce(
    (acc, c) => (acc << 1) | (c === "#" ? 1 : 0),
    0,
  );
}

function parseButton(text: string, numIndicators: number): number {
  return text.slice(1, -1).split(",")
    .map((v) => Number.parseInt(v))
    .reduce((acc, n) => acc | (1 << (numIndicators - n - 1)), 0);
}

function parseJoltage(text: string): number[] {
  return text.slice(1, -1).split(",").map((v) => Number.parseInt(v));
}

function parseMachine(text: string): Machine {
  const split = text.split(" ");
  const indicator = parseIndicator(split[0]);
  const numIndicators = split[0].length - 2;
  const buttons = split.slice(1, -1).map((s) => parseButton(s, numIndicators));
  const buttonsRaw = split.slice(1, -1).map(parseJoltage);
  const joltages = parseJoltage(split[split.length - 1]);

  return { indicator, buttons, buttonsRaw, joltages };
}

function solvePart1ForMachine(machine: Machine): number {
  // solver with ID-DFS
  const dldfs = function (
    indicator: number,
    buttons: number[],
    depth: number,
  ): boolean {
    if (indicator === machine.indicator) return true;
    if (depth <= 0) return false;

    for (let i = 0; i < buttons.length; i++) {
      if (dldfs(indicator ^ buttons[i], buttons.toSpliced(i, 1), depth - 1)) {
        return true;
      }
    }

    return false;
  };

  for (let d = 1; d <= machine.buttons.length; d++) {
    if (dldfs(0, machine.buttons, d)) return d;
  }
  return Infinity;
}

function solvePart1(machines: Machine[]): number {
  return machines.map(solvePart1ForMachine).reduce((acc, cur) => acc + cur, 0);
}

function solvePart2ForMachine(machine: Machine): number {
  const buttons = machine.buttonsRaw.map((button) => {
    const result = machine.joltages.map(() => 0);
    for (const b of button) {
      result[b] = 1;
    }
    return result;
  });
  buttons.sort((a, b) => a.indexOf(1) - b.indexOf(1));

  let calls = 0;

  const search = function (
    remaining: number[],
    sum: number,
    buttons: number[][],
  ): number | null {
    calls += 1;

    if (remaining.every((v) => v == 0)) return sum;
    if (remaining.some((v) => v < 0)) return null;
    if (buttons.length === 0) return null;
    if (remaining.findIndex((v) => v > 0) < buttons[0].indexOf(1)) return null;

    // console.log(sum, remaining);

    let min = null;
    for (let i = 0; i < buttons.length; i++) {
      const scaleMax = Math.max(...(vecMul(remaining, buttons[i])));
      for (let s = 0; s <= scaleMax; s++) {
        const result = search(
          vecSub(remaining, vecScale(buttons[i], s)),
          sum + s,
          buttons.slice(i + 1),
        );

        if (result !== null && (min === null || result < min)) {
          min = result;
        }
      }
    }

    return min;
  };

  const result = search(machine.joltages, 0, buttons) ?? Infinity;
  console.log("calls: ", calls);
  return result;
}

function solvePart2(machines: Machine[]): number {
  return machines.map(solvePart2ForMachine).reduce((acc, cur) => acc + cur, 0);
}

const lines = Deno.stdin.readable
  .pipeThrough(new TextDecoderStream())
  .pipeThrough(new TextLineStream());
const machines = (await Array.fromAsync(lines)).map(parseMachine);

console.log(machines[0]);
console.log(solvePart2ForMachine(machines[0]));
console.log(solvePart2ForMachine(machines[1]));
console.log(solvePart2ForMachine(machines[2]));
// console.log(solvePart2(machines));
