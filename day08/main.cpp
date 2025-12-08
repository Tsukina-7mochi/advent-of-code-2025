#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

#define PART 2

struct Point {
  int x;
  int y;
  int z;

  bool operator==(const Point &other) const {
    return x == other.x && y == other.y && z == other.z;
  }

  long long distanceTo(const Point &other) const {
    long long dx = x - other.x;
    long long dy = y - other.y;
    long long dz = z - other.z;
    return dx * dx + dy * dy + dz * dz;
  }
};

struct ItemPair {
  int first;
  int second;
  long long distance;
};

struct UnionFindTree {
  std::vector<int> parent;

  int root(int x) {
    if (parent[x] != x) {
      parent[x] = root(parent[x]);
    }
    return parent[x];
  }

  int unite(int x, int y) {
    int rootX = root(x);
    int rootY = root(y);
    if (rootX != rootY) {
      parent[rootY] = rootX;
    }
    return rootX;
  }

  void compact() {
    for (int i = 0; i < parent.size(); ++i) {
      root(i);
    }
  }

  bool is_one_component() {
    int r = root(0);
    for (int i = 1; i < parent.size(); ++i) {
      if (root(i) != r) {
        return false;
      }
    }
    return true;
  }

  UnionFindTree(int n) : parent(n) {
    for (int i = 0; i < n; ++i) {
      parent[i] = i;
    }
  }
};

int main(int argc, char **argv) {
  int numConnection = std::stoi(argv[1]);
  int topN = std::stoi(argv[2]);

  std::vector<Point> points;
  std::vector<ItemPair> pairs;

  std::string line;
  while (std::getline(std::cin, line)) {
    int x, y, z;
    sscanf(line.c_str(), "%d,%d,%d", &x, &y, &z);
    points.push_back(Point{x, y, z});
  }

  for (int i = 0; i < points.size(); ++i) {
    for (int j = i + 1; j < points.size(); ++j) {
      long long dist = points[i].distanceTo(points[j]);
      pairs.push_back(ItemPair{i, j, dist});
    }
  }

  std::sort(pairs.begin(), pairs.end(),
            [](const ItemPair &a, const ItemPair &b) {
              return a.distance < b.distance;
            });

  UnionFindTree uft(points.size());

#if PART == 1
  for (int i = 0; i < numConnection && i < pairs.size(); ++i) {
    uft.unite(pairs[i].first, pairs[i].second);
  }
  uft.compact();

  std::vector<int> componentSizes(points.size(), 0);
  for (int i = 0; i < points.size(); ++i) {
    componentSizes[uft.parent[i]]++;
  }

  std::sort(componentSizes.begin(), componentSizes.end(), std::greater<int>());

  int result = 1;
  for (int i = 0; i < topN && i < componentSizes.size(); ++i) {
    result *= componentSizes[i];
    if (componentSizes[i] == 0)
      break;
  }

  std::cout << result << std::endl;

#else
  int i = 0;
  while (!uft.is_one_component() && i < pairs.size()) {
    uft.unite(pairs[i].first, pairs[i].second);
    i++;
  }

  // for (int j = std::max(0, i - 5); j < i + 5 && j < pairs.size(); j++) {
  //   std::cout << "Connection " << j << ": (" << points[pairs[j].first].x <<
  //   ", "
  //             << points[pairs[j].first].y << ", " << points[pairs[j].first].z
  //             << ") <-> (" << points[pairs[j].second].x << ", "
  //             << points[pairs[j].second].y << ", " <<
  //             points[pairs[j].second].z
  //             << ") with distance " << pairs[j].distance << std::endl;
  // }

  std::cout << points[pairs[i - 1].first].x * points[pairs[i - 1].second].x
            << std::endl;

#endif

  return 0;
}
