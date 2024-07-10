/**
 * Class containing an type of Strategy.
 * @author	081028AW
 */
public class StrategySanchezJuarez1 extends Strategy
   {
  /**
   * Encoding for a strategy.
   */

   int opponentLastMove = 1;
   int numDefects;
   int myLastMove;
   String name;

  // 0 = defect, 1 = cooperate

   public StrategySanchezJuarez1()
      {
         name = "Sam";
         opponentLastMove = 1;
         numDefects = 0;
      }  /* Strategy: If user cooperates, also cooperate, if not go random  */

   public int nextMove()
      {

      if (opponentLastMove == 1){
         numDefects = 0;
         return 0;
      }
      
      else{
         numDefects++;
         if(numDefects >= 3){
            return 0;}
         else{
            if (Math.random() < 0.5)  return 1;
               return 0;}
         }
        /* nextMove */
   }

   public void saveOpponentMove(int move)  { opponentLastMove = move; }
   public int getOpponentLastMove()  { return opponentLastMove; }
   public void saveMyMove(int move)  { myLastMove = move; }
   public int getMyLastMove()  { return myLastMove; }
   public String getName()  { return name; }
   }  /* class Strategy */

