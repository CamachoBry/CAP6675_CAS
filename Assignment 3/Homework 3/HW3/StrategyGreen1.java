/**
 * Class containing the look back three (Joseph Green's) strategy.
 * @author	Joseph Green
 */
 
 import java.util.Queue;
 import java.util.LinkedList;
 
 
public class StrategyGreen1 extends Strategy
   {
  /**
   * Encoding for tit-for-tat strategy.
   */

   int initcount;
   Queue<Integer> prevRound;
   int move;

  // 0 = defect, 1 = cooperate

   public StrategyGreen1()
      {
      name = "Joseph";
      initcount = 0;
      prevRound = new LinkedList<Integer>();
      for (int i =0; i < 3; i++){
         prevRound.add(1);
      }
      }  /* Look back at the opponents move three rounds ago and choose what will beat that */

   public int nextMove()
      {
         
         move = prevRound.remove();
         prevRound.add(opponentLastMove);
         if (move == 1){
            /*Don't defect on every cooperation to lessen the effect of retailation strategies*/
            if (Math.random() < .5){return 1;}
            else {return 0;}
         }
         else {
            return 0;   
         }
      }  /* nextMove */

   }  /* class LookBackThree */