class Solver {
  // Constant / Original
  final max_count_solution = 20;
  double target = 24;
  List<double> numbers = [4,5,6,7];
  final double infinity = double.infinity;
  final List<String> operators = ["+","-","*","/"];
//   final List<String> operators = ["/"];
  final Map<String, int> level = {"+": 1, "-": 1, "*": 2, "/": 2};

  // Temp
  int iMin = 0;
  int iMax = 0;

  // States
  List<int> bitState = [];

  Map<String, int> dp = {};
  Set<String> solutions = {};
  int countSolution = 0;

  int minimum(int a, int b) => a < b ? a : b;

  int maximum(int a, int b) => a > b ? a : b;

  double calculate(double a, double b, String operator) {
    if (operator == '+') {
      return a + b;
    } else if (operator == '-') {
      return a - b;
    } else if (operator == '*') {
      return a * b;
    } else if (operator == '/' && b != 0) {
      return a / b;
    }
    return infinity;
  }

  List<String> solve(List<int> new_numbers, double new_target) {
    target = new_target;
    numbers.clear();
    // numbers = List.from(new_numbers);
    numbers = new_numbers.map((intNumber) => intNumber.toDouble()).toList();
    print(numbers);
    dp.clear();
    solutions.clear();
    countSolution = 0;
    bitState =  List.generate(this.numbers.length, (index) => 0);
    List<String> stringList =
    new_numbers.map<String>((int number) => number.toString()).toList();
    List<int> operatorList = List.generate(numbers.length, (index) => 0);
    _solve(stringList, List<double>.from(numbers), operatorList, 0);
    return solutions.toList();
  }

  void _solve(List<String> curSolution, List<double> curNumbers,
      List<int> curOperators, int depth) {
//     print('$depth >> ${curSolution}');
    if (depth == this.numbers.length - 1) {
//       print(curSolution);
      if (curNumbers[0] == this.target) {
        solutions.add(curSolution[0]);
        countSolution++;
//         print(curSolution[0]);
      }
      return;
    }
    if(countSolution > max_count_solution){
      return;
    }
    String tempState = "";
    double temp = 0;
    int prev1 = 0;
    int prev2 = 0;
    for (int i = 0; i < numbers.length; i++) {
      if (curNumbers[i] == double.infinity) {
        continue;
      }
      for (int j = 0; j < numbers.length; j++) {
        if (i == j || curNumbers[j] == double.infinity) {
          continue;
        }
        for (int k = 0; k < this.operators.length; k++) {
          temp = calculate(curNumbers[i], curNumbers[j], this.operators[k]);
          if (temp == double.infinity || temp.isNaN) {
            continue;
          }
          prev1 = bitState[i];
          prev2 = bitState[j];
          bitState[i] = 1;
          bitState[j] = 1;
          tempState = bitState.join("") + '$temp';
          if (dp[tempState] == null) {
//             dp[tempState] = 1;
            List<double> tempNumbers = List.from(curNumbers);
            List<String> tempSolution = List.from(curSolution);
            List<int> tempOperators = List.from(curOperators);
            iMin = minimum(i, j);
            iMax = maximum(i, j);
            if (tempOperators[i] == 0) {
              tempOperators[i] = this.level[this.operators[k]]!;
            }
            if (tempOperators[j] == 0) {
              tempOperators[j] = this.level[this.operators[k]]!;
            }
            if (tempOperators[i] >= this.level[this.operators[k]]!) {
              tempSolution[iMin] = '${curSolution[i]} ';
            } else {
              tempSolution[iMin] = '(${curSolution[i]}) ';
            }
            tempSolution[iMin] += '${this.operators[k]} ';
            if (tempOperators[j] >= this.level[this.operators[k]]!) {

              if ((this.operators[k] == "-" || this.operators[k] == '/') && curOperators[j] != 0) {
                tempSolution[iMin] += '(${curSolution[j]})';
              } else {
                tempSolution[iMin] += '${curSolution[j]}';
              }
//               print("${tempOperators[j]}<>${this.operators[k]}<>${curOperators[j]} >> ${tempSolution[iMin]} = $temp");
            } else {
              tempSolution[iMin] += '(${curSolution[j]})';
            }
            tempNumbers[iMin] = temp;
            tempNumbers[iMax] = double.infinity;
            tempOperators[iMin] = level[operators[k]]!;
            tempSolution[iMax] = "";
//             print('$depth >> ${tempSolution}');
            _solve(tempSolution, tempNumbers, tempOperators, depth + 1);
          }
          bitState[i] = prev1;
          bitState[j] = prev2;
        }
      }
    }
  }
}

