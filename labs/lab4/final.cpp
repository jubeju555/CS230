#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <cstdio>
#include <cstring>
using namespace std;

struct MyStruct {
        long value;
        char key[21];
};

extern "C" {
        long find(const MyStruct array[], long num_values, const char *key);
}

int main(int argc, char *argv[]) {
        vector<MyStruct> vs;
        string line;
        char ckey[21];
        ifstream fin;

        if (argc != 2) {
                cout << "Usage: " << argv[0] << " <input file>\n";
                return -1;
        }

        fin.open(argv[1]);
        if (!fin) {
                perror(argv[1]);
                return -2;
        }

        while (getline(fin, line)) {
                MyStruct ms;
                string key;
                istringstream sin(line);
                sin >> ms.value;
                getline(sin, key);
                memset(ms.key, 0, sizeof(ms.key));
                memcpy(ms.key, key.c_str() + 1, key.size()-1);
                vs.push_back(ms);
        }

        fin.close();

        cout << "Key/Values from " << argv[1] << '\n';
        for (const auto &ms : vs) {
                printf("%-23s -> %ld\n", ms.key, ms.value);
        }
        cout << endl;
        while (true) {
                string key;
                cout << "Enter key to find: ";
                if (!getline(cin, key)) {
                        break;
                }
                if (key == "") {
                        cout << "Press CTRL-D to quit.\n";
                        continue;
                }
                memset(ckey, 0, sizeof(ckey));
                memcpy(ckey, key.c_str(), key.length());
                long idx = find(&vs[0], vs.size(), ckey);
                if (idx == vs.size()) {
                        cout << "Key not found.\n";
                }
                else if (idx > vs.size()) {
                                printf("  ->>> Index exceeds size <<<-\n");
                }
                else {
                        printf("Key found at %ld with value %ld.\n", idx, vs[idx].value);
                }
        }

        return 0;
}


// needs to search through array and  match key, if mmatches return index where key was found, if not return num_values - in riscv assembly, 