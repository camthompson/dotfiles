// @ts-nocheck
// eslint-disable

// ── Primitives & Literal Types ───────────────────────────────────────────────
const name: string = "syntax-highlight-demo";
const version: number = 3.14;
const enabled: boolean = true;
const nothing: null = null;
const missing: undefined = undefined;
const id: bigint = 9007199254740991n;
const unique: symbol = Symbol("unique");
const template = `Hello, ${name}! Version ${version}`;

// ── Enums ────────────────────────────────────────────────────────────────────
enum Direction {
  Up = "UP",
  Down = "DOWN",
  Left = "LEFT",
  Right = "RIGHT",
}

const enum StatusCode {
  OK = 200,
  NotFound = 404,
  ServerError = 500,
}

// ── Interfaces & Type Aliases ────────────────────────────────────────────────
interface User {
  readonly id: number;
  name: string;
  email?: string;
  role: "admin" | "editor" | "viewer";
  metadata: Record<string, unknown>;
  createdAt: Date;
}

type Prettify<T> = { [K in keyof T]: T[K] } & {};

type Result<T, E = Error> = { ok: true; value: T } | { ok: false; error: E };

type EventMap = {
  click: { x: number; y: number };
  keydown: { key: string; code: number };
  resize: { width: number; height: number };
};

// ── Utility Types ────────────────────────────────────────────────────────────
type PartialUser = Partial<User>;
type RequiredUser = Required<User>;
type UserName = Pick<User, "name" | "email">;
type WithoutMeta = Omit<User, "metadata">;
type ReadonlyUser = Readonly<User>;
type NullableString = string | null | undefined;
type NonNullString = NonNullable<NullableString>;

// ── Conditional & Mapped Types ───────────────────────────────────────────────
type IsString<T> = T extends string ? "yes" : "no";
type A = IsString<"hello">; // "yes"
type B = IsString<42>; // "no"

type Getters<T> = {
  [K in keyof T as `get${Capitalize<string & K>}`]: () => T[K];
};

type UserGetters = Getters<Pick<User, "name" | "email">>;

// ── Template Literal Types ───────────────────────────────────────────────────
type HTTPMethod = "GET" | "POST" | "PUT" | "DELETE" | "PATCH";
type APIRoute = `/api/${string}`;
type Endpoint = `${HTTPMethod} ${APIRoute}`;

// ── Generics & Constraints ───────────────────────────────────────────────────
function identity<T>(value: T): T {
  return value;
}

function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}

class TypedMap<K extends string | number, V> {
  private store = new Map<K, V>();

  set(key: K, value: V): this {
    this.store.set(key, value);
    return this;
  }

  get(key: K): V | undefined {
    return this.store.get(key);
  }

  entries(): IterableIterator<[K, V]> {
    return this.store.entries();
  }
}

// ── Decorators (Stage 3) ─────────────────────────────────────────────────────
function logged<T extends (...args: any[]) => any>(
  target: T,
  context: ClassMethodDecoratorContext,
) {
  const name = String(context.name);
  return function (this: any, ...args: Parameters<T>): ReturnType<T> {
    console.log(`→ ${name}(${args.map(String).join(", ")})`);
    const result = target.apply(this, args);
    console.log(`← ${name} returned`, result);
    return result;
  } as T;
}

// ── Classes ──────────────────────────────────────────────────────────────────
abstract class BaseEntity {
  abstract get displayName(): string;
  toString() {
    return `[${this.displayName}]`;
  }
}

class UserEntity extends BaseEntity implements User {
  readonly id: number;
  role: User["role"] = "viewer";
  metadata: Record<string, unknown> = {};
  createdAt = new Date();

  constructor(
    id: number,
    public name: string,
    public email?: string,
  ) {
    super();
    this.id = id;
  }

  get displayName(): string {
    return `${this.name} (#${this.id})`;
  }

  @logged
  greet(greeting: string): string {
    return `${greeting}, ${this.name}!`;
  }

  static fromJSON(json: string): UserEntity {
    const { id, name, email } = JSON.parse(json) as User;
    return new UserEntity(id, name, email);
  }
}

// ── Async / Generators / Iterators ───────────────────────────────────────────
async function fetchData<T>(url: string): Promise<Result<T>> {
  try {
    const response = await fetch(url);
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const data: T = await response.json();
    return { ok: true, value: data };
  } catch (error) {
    return { ok: false, error: error as Error };
  }
}

function* range(start: number, end: number, step = 1): Generator<number> {
  for (let i = start; i < end; i += step) {
    yield i;
  }
}

async function* streamLines(url: string): AsyncGenerator<string> {
  const res = await fetch(url);
  const reader = res.body!.getReader();
  const decoder = new TextDecoder();
  let buffer = "";

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    buffer += decoder.decode(value, { stream: true });
    const lines = buffer.split("\n");
    buffer = lines.pop()!;
    for (const line of lines) {
      yield line;
    }
  }
  if (buffer) yield buffer;
}

// ── Discriminated Unions & Exhaustive Checks ─────────────────────────────────
type Shape =
  | { kind: "circle"; radius: number }
  | { kind: "rectangle"; width: number; height: number }
  | { kind: "triangle"; base: number; height: number };

function area(shape: Shape): number {
  switch (shape.kind) {
    case "circle":
      return Math.PI * shape.radius ** 2;
    case "rectangle":
      return shape.width * shape.height;
    case "triangle":
      return (shape.base * shape.height) / 2;
    default: {
      const _exhaustive: never = shape;
      return _exhaustive;
    }
  }
}

// ── Satisfies Operator ───────────────────────────────────────────────────────
const palette = {
  red: [255, 0, 0],
  green: "#00ff00",
  blue: [0, 0, 255],
} satisfies Record<string, string | number[]>;

// ── Using Declaration (Stage 3) ──────────────────────────────────────────────
class FileHandle implements Disposable {
  constructor(public path: string) {
    console.log(`Opened: ${path}`);
  }
  [Symbol.dispose](): void {
    console.log(`Closed: ${this.path}`);
  }
}

function processFile() {
  using handle = new FileHandle("/tmp/data.txt");
  console.log(`Processing: ${handle.path}`);
}

// ── Regex & Pattern Matching ─────────────────────────────────────────────────
const urlPattern = /^https?:\/\/[\w.-]+(?:\.[\w.-]+)+[\w\-._~:/?#[\]@!$&'()*+,;=]*$/gi;
const dateRegex = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/;
const match = "2026-02-07".match(dateRegex);
const { year, month, day } = match?.groups ?? { year: "", month: "", day: "" };

// ── Promises & Concurrency ───────────────────────────────────────────────────
const delay = (ms: number) => new Promise<void>((resolve) => setTimeout(resolve, ms));

async function concurrent() {
  const [users, posts, comments] = await Promise.all([
    fetchData<User[]>("/api/users"),
    fetchData<unknown[]>("/api/posts"),
    fetchData<unknown[]>("/api/comments"),
  ]);

  const fastest = await Promise.race([delay(100).then(() => "slow"), delay(10).then(() => "fast")]);

  const settled = await Promise.allSettled([
    Promise.resolve(1),
    Promise.reject(new Error("fail")),
    Promise.resolve(3),
  ]);

  return { users, posts, comments, fastest, settled };
}

// ── Type Guards & Assertions ─────────────────────────────────────────────────
function isUser(value: unknown): value is User {
  return typeof value === "object" && value !== null && "id" in value && "name" in value;
}

function assertDefined<T>(value: T | null | undefined, msg?: string): asserts value is T {
  if (value == null) throw new Error(msg ?? "Value is null or undefined");
}

// ── Infer Keyword ────────────────────────────────────────────────────────────
type UnpackPromise<T> = T extends Promise<infer U> ? U : T;
type Resolved = UnpackPromise<Promise<string>>; // string

type FirstArg<T> = T extends (first: infer F, ...rest: any[]) => any ? F : never;
type NameArg = FirstArg<(name: string, age: number) => void>; // string

// ── Tuple Types ──────────────────────────────────────────────────────────────
type Point2D = [x: number, y: number];
type Point3D = [...Point2D, z: number];
type AtLeastOne<T> = [T, ...T[]];
type ReadonlyPair = readonly [string, number];

const coords: Point3D = [10, 20, 30];
const tags: AtLeastOne<string> = ["typescript"];

// ── Intersection Types ───────────────────────────────────────────────────────
type Timestamped = { createdAt: Date; updatedAt: Date };
type SoftDeletable = { deletedAt: Date | null };
type AuditedUser = User & Timestamped & SoftDeletable;

// ── Namespace ────────────────────────────────────────────────────────────────
namespace Validation {
  export interface Rule<T> {
    validate(value: T): boolean;
    message: string;
  }

  export function compose<T>(...rules: Rule<T>[]): Rule<T> {
    return {
      validate: (value) => rules.every((r) => r.validate(value)),
      message: rules.map((r) => r.message).join("; "),
    };
  }
}

// ── Module Augmentation ──────────────────────────────────────────────────────
declare global {
  interface Array<T> {
    unique(): T[];
  }
}

Array.prototype.unique = function <T>(this: T[]): T[] {
  return [...new Set(this)];
};

// ═══════════════════════════════════════════════════════════════════════════════
// ── React / JSX ──────────────────────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════
import React, {
  useState,
  useEffect,
  useRef,
  useMemo,
  useCallback,
  useReducer,
  useContext,
  createContext,
  forwardRef,
  type FC,
  type ReactNode,
  type PropsWithChildren,
  type ComponentProps,
  type CSSProperties,
  type MouseEventHandler,
  type KeyboardEvent,
  type ChangeEvent,
} from "react";

// ── Context ──────────────────────────────────────────────────────────────────
interface ThemeContextValue {
  mode: "light" | "dark";
  toggle: () => void;
  colors: { bg: string; fg: string; accent: string };
}

const ThemeContext = createContext<ThemeContextValue | null>(null);

function useTheme(): ThemeContextValue {
  const ctx = useContext(ThemeContext);
  if (!ctx) throw new Error("useTheme must be used within ThemeProvider");
  return ctx;
}

// ── Custom Hook ──────────────────────────────────────────────────────────────
function useLocalStorage<T>(key: string, initial: T) {
  const [value, setValue] = useState<T>(() => {
    try {
      const stored = localStorage.getItem(key);
      return stored ? (JSON.parse(stored) as T) : initial;
    } catch {
      return initial;
    }
  });

  useEffect(() => {
    localStorage.setItem(key, JSON.stringify(value));
  }, [key, value]);

  return [value, setValue] as const;
}

function useDebounce<T>(value: T, delay: number): T {
  const [debounced, setDebounced] = useState(value);
  useEffect(() => {
    const timer = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);
  return debounced;
}

// ── Reducer ──────────────────────────────────────────────────────────────────
interface CounterState {
  count: number;
  history: number[];
}

type CounterAction =
  | { type: "increment"; by?: number }
  | { type: "decrement"; by?: number }
  | { type: "reset" }
  | { type: "set"; value: number };

function counterReducer(state: CounterState, action: CounterAction): CounterState {
  switch (action.type) {
    case "increment":
      return {
        count: state.count + (action.by ?? 1),
        history: [...state.history, state.count],
      };
    case "decrement":
      return {
        count: state.count - (action.by ?? 1),
        history: [...state.history, state.count],
      };
    case "reset":
      return { count: 0, history: [] };
    case "set":
      return {
        count: action.value,
        history: [...state.history, state.count],
      };
  }
}

// ── Generic Component ────────────────────────────────────────────────────────
interface ListProps<T> {
  items: T[];
  renderItem: (item: T, index: number) => ReactNode;
  keyExtractor: (item: T) => string | number;
  emptyMessage?: string;
  className?: string;
}

function List<T>({
  items,
  renderItem,
  keyExtractor,
  emptyMessage = "No items",
  className,
}: ListProps<T>): JSX.Element {
  if (items.length === 0) {
    return <p className="empty-state">{emptyMessage}</p>;
  }

  return (
    <ul className={className}>
      {items.map((item, i) => (
        <li key={keyExtractor(item)}>{renderItem(item, i)}</li>
      ))}
    </ul>
  );
}

// ── forwardRef Component ─────────────────────────────────────────────────────
interface InputProps extends Omit<ComponentProps<"input">, "onChange"> {
  label: string;
  error?: string;
  onChange?: (value: string) => void;
}

const TextInput = forwardRef<HTMLInputElement, InputProps>(
  ({ label, error, onChange, ...props }, ref) => {
    const handleChange = useCallback(
      (e: ChangeEvent<HTMLInputElement>) => onChange?.(e.target.value),
      [onChange],
    );

    return (
      <div className="field">
        <label htmlFor={props.id}>{label}</label>
        <input ref={ref} onChange={handleChange} aria-invalid={!!error} {...props} />
        {error && (
          <span role="alert" className="error">
            {error}
          </span>
        )}
      </div>
    );
  },
);

TextInput.displayName = "TextInput";

// ── Main App Component ───────────────────────────────────────────────────────
interface AppProps {
  title?: string;
  initialCount?: number;
}

const App: FC<AppProps> = ({ title = "Demo", initialCount = 0 }) => {
  // State
  const [query, setQuery] = useLocalStorage("search", "");
  const debouncedQuery = useDebounce(query, 300);
  const [state, dispatch] = useReducer(counterReducer, {
    count: initialCount,
    history: [],
  });
  const inputRef = useRef<HTMLInputElement>(null);
  const { mode, toggle, colors } = useTheme();

  // Derived state
  const filteredUsers = useMemo(() => {
    const q = debouncedQuery.toLowerCase();
    return mockUsers.filter(
      (u) => u.name.toLowerCase().includes(q) || u.email?.toLowerCase().includes(q),
    );
  }, [debouncedQuery]);

  // Effects
  useEffect(() => {
    const handler = (e: globalThis.KeyboardEvent) => {
      if (e.key === "/" && e.metaKey) {
        e.preventDefault();
        inputRef.current?.focus();
      }
    };
    document.addEventListener("keydown", handler);
    return () => document.removeEventListener("keydown", handler);
  }, []);

  // Handlers
  const handleClick: MouseEventHandler<HTMLButtonElement> = (e) => {
    e.preventDefault();
    dispatch({ type: "increment" });
  };

  const handleKeyDown = (e: KeyboardEvent<HTMLDivElement>) => {
    if (e.key === "Escape") setQuery("");
  };

  // Styles
  const containerStyle: CSSProperties = {
    backgroundColor: colors.bg,
    color: colors.fg,
    minHeight: "100vh",
    padding: "2rem",
    fontFamily: "'Inter', system-ui, sans-serif",
    transition: "background-color 0.3s ease",
  };

  return (
    <div style={containerStyle} onKeyDown={handleKeyDown}>
      <header>
        <h1>{title}</h1>
        <button
          onClick={toggle}
          aria-label={`Switch to ${mode === "light" ? "dark" : "light"} mode`}
        >
          {mode === "light" ? "Dark" : "Light"} Mode
        </button>
      </header>

      <section aria-label="Counter">
        <p>
          Count: <strong>{state.count}</strong>
        </p>
        <div role="group" aria-label="Counter controls">
          <button onClick={handleClick}>+</button>
          <button onClick={() => dispatch({ type: "decrement" })}>-</button>
          <button onClick={() => dispatch({ type: "reset" })}>Reset</button>
        </div>
        {state.history.length > 0 && (
          <details>
            <summary>History ({state.history.length})</summary>
            <ol>
              {state.history.map((val, i) => (
                <li key={i}>{val}</li>
              ))}
            </ol>
          </details>
        )}
      </section>

      <section aria-label="Search">
        <TextInput
          ref={inputRef}
          id="search"
          label="Search users"
          placeholder="Type to filter... (Cmd+/)"
          value={query}
          onChange={setQuery}
        />
      </section>

      <section aria-label="User list">
        <List
          items={filteredUsers}
          keyExtractor={(u) => u.id}
          renderItem={(user) => (
            <article>
              <h3>{user.name}</h3>
              {user.email && <a href={`mailto:${user.email}`}>{user.email}</a>}
              <span className={`badge badge--${user.role}`}>{user.role}</span>
            </article>
          )}
          emptyMessage={`No users matching "${debouncedQuery}"`}
        />
      </section>

      {/* Fragment shorthand */}
      <>
        <hr />
        <footer>
          <small>
            &copy; {new Date().getFullYear()} {title}
          </small>
        </footer>
      </>
    </div>
  );
};

// ── Provider Wrapper ─────────────────────────────────────────────────────────
function ThemeProvider({ children }: PropsWithChildren) {
  const [mode, setMode] = useState<"light" | "dark">("light");

  const value = useMemo<ThemeContextValue>(
    () => ({
      mode,
      toggle: () => setMode((m) => (m === "light" ? "dark" : "light")),
      colors:
        mode === "light"
          ? { bg: "#ffffff", fg: "#111111", accent: "#0066ff" }
          : { bg: "#111111", fg: "#eeeeee", accent: "#66aaff" },
    }),
    [mode],
  );

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>;
}

// ── Mock Data ────────────────────────────────────────────────────────────────
const mockUsers: User[] = [
  {
    id: 1,
    name: "Alice",
    email: "alice@example.com",
    role: "admin",
    metadata: {},
    createdAt: new Date(),
  },
  { id: 2, name: "Bob", role: "editor", metadata: { department: "eng" }, createdAt: new Date() },
  {
    id: 3,
    name: "Charlie",
    email: "charlie@example.com",
    role: "viewer",
    metadata: {},
    createdAt: new Date(),
  },
];

// ── Default Export ───────────────────────────────────────────────────────────
export default function Root() {
  return (
    <ThemeProvider>
      <App title="Syntax Highlight Demo" initialCount={42} />
    </ThemeProvider>
  );
}

export { App, ThemeProvider, useTheme, useLocalStorage, useDebounce, List, TextInput };
export type { User, Result, Shape, EventMap, ThemeContextValue, ListProps };
