#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SGN(x) (((x) > 0) - ((x) < 0))

#define PART 2
#define BUF_SIZE 1024

typedef struct {
  long long start; // inclusive
  long long end;   // exclusive
} range;

bool range_contains(const range *r, long long x) {
  return r->start <= x && x < r->end;
}

int range_compare(const void *r1, const void *r2) {
  return (int)SGN((*((range **)r1))->start - (*((range **)r2))->start);
}

typedef struct {
  void **items;
  size_t length;
  size_t capacity;
} vector;

vector new_vector() {
  vector v;
  v.items = malloc(sizeof(void *));
  v.length = 0;
  v.capacity = 1;

  return v;
}

void vector_free_with_items(const vector *v) {
  for (int i = 0; i < v->length; i++) {
    free(v->items[i]);
  }
  free(v->items);
}

void vector_push(vector *v, void *item) {
  if (v->length >= v->capacity - 1) {
    // double the vector size
    v->capacity *= 2;
    v->items = realloc(v->items, (sizeof(void *)) * v->capacity);
  }
  v->items[v->length] = item;
  v->length += 1;
}

bool any_range_includes(const vector *v, const size_t id) {
  for (int i = 0; i < v->length; i++) {
    if (range_contains((range *)v->items[i], id)) {
      return true;
    }
  }
  return false;
}

int main() {
  char buffer[BUF_SIZE];
  vector ranges = new_vector();
  size_t fresh_count = 0;

  while (fgets(buffer, BUF_SIZE, stdin)) {
    if (buffer[0] == '\n') {
      break;
    }

    *strchr(buffer, '\n') = '\0';

    char *delimiter = strchr(buffer, '-');
    *delimiter = '\0';

    range *r = malloc(sizeof(range));
    r->start = strtoll(buffer, NULL, 10);
    r->end = strtoll(delimiter + 1, NULL, 10) + 1;

    vector_push(&ranges, r);
  }

#if PART == 1
  while (fgets(buffer, BUF_SIZE, stdin)) {
    long long id = strtoll(buffer, NULL, 10);
    if (any_range_includes(&ranges, id)) {
      fresh_count += 1;
    }
  }
#elif PART == 2
  qsort(ranges.items, ranges.length, sizeof(void *), range_compare);

  long long id = 0;
  for (int i = 0; i < ranges.length; i++) {
    range *r = (range *)ranges.items[i];

    if (id < r->start) {
      id = r->start;
    } else if (id >= r->end) {
      continue;
    }

    fresh_count += r->end - id;

    id = r->end;
  }
#endif

  printf("%ld\n", fresh_count);

  vector_free_with_items(&ranges);

  return 0;
}
