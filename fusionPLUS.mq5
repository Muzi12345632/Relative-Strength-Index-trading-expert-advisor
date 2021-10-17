//+------------------------------------------------------------------+
//|                                                   fusionPLUS.mq5 |
//|                                Copyright 2021, muziwandile nkomo |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, muziwandile nkomo"
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#property strict

//#define LIC_EXPIRES_DAYS 30



#include <Trade\Trade.mqh>
//\#include <Muzi\LicenseCheck\LicenseCheck.mqh
 

CTrade trade;
int rsiHandle;
ulong posTicket;
int rsiHandle2;


  
int OnInit()
  {
//---

    rsiHandle = iRSI(_Symbol,PERIOD_M1,14, PRICE_CLOSE); 
     rsiHandle2  = iRSI(_Symbol,PERIOD_M5,14, PRICE_CLOSE);
    
    
    //if (!LicenseCheck()) return(INIT_FAILED);
   
 
   
//---
  return 0;
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  } 
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double rsi[];
   double rsi2[];
   CopyBuffer(rsiHandle,0,1,1,rsi);
   CopyBuffer(rsiHandle2,0,1,1,rsi2);
   
   if (rsi[0] < 30 && rsi2[0] <= 40) {
       if  (posTicket >  0   && PositionSelectByTicket(posTicket)) {
            int posType = (int)PositionGetInteger(POSITION_TYPE);
            //trade.PositionClose(posTicket);
            posType = 0;    
       }
   
     if (posTicket <= 0) {
      trade.Sell(0.2,_Symbol);
      posTicket = trade.ResultOrder();
     }
      
   }else if (rsi[0] >100 && rsi2[0] > 100 ) {
      if (posTicket > 0 &&  PositionSelectByTicket(posTicket)) {
         int posType = (int)PositionGetInteger(POSITION_TYPE);
         if (posType == POSITION_TYPE_BUY) {
           // trade.PositionClose(posTicket);
            posType = 0;
         }
      }
      if  (posTicket <= 0 ) { 
         trade.Buy(0.2,_Symbol);
         posTicket = trade.ResultOrder();
 
   }

      }
  
   
   if (PositionSelectByTicket(posTicket)) {
      double posPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      double posSl  = PositionGetDouble(POSITION_SL);
      double posTp  = PositionGetDouble(POSITION_TP);
      int posType  = (int)PositionGetInteger(POSITION_TYPE);
      
      if (posType == POSITION_TYPE_BUY ){
      
      if (posSl == 0) {
         double sl = posPrice - 5000*SymbolInfoDouble(_Symbol,SYMBOL_POINT);
         double tp = posPrice + 2000*SymbolInfoDouble(_Symbol,SYMBOL_POINT);;
         trade.PositionModify(posTicket, sl, tp );
         
      }
     }else if (posType == POSITION_TYPE_SELL) {
         if (posSl ==0 ) {
            double sl =  posPrice + 5000*SymbolInfoDouble(_Symbol,SYMBOL_POINT);
            double tp = posPrice - 2000*SymbolInfoDouble(_Symbol,SYMBOL_POINT);;
            trade.PositionModify(posTicket, sl, tp);
           
         }
     }
  }else {
       posTicket = 0;
  }
  
   Comment(rsi[0], "\n",posTicket);
  }
//+------------------------------------------------------------------+
