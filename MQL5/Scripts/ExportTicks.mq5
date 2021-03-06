//+------------------------------------------------------------------+
//|                                                  ExportTicks.mq5 |
//|                                                           Рэндом |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Рэндом"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs
//--- input parameters
enum TickMode
{
   All,
   AskBid,
   Trades
};
input datetime Date=D'2016.10.21';
input TickMode Mode=Trades;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

void OnStart()
  {
//---
   MqlTick t[];
   int rz=COPY_TICKS_ALL;
   switch(Mode)
   {
      case All: rz=COPY_TICKS_ALL; break;
      case AskBid: rz=COPY_TICKS_INFO; break;
      case Trades: rz=COPY_TICKS_TRADE; break;
   }
   CopyTicksRange(Symbol(),t,rz,(ulong)(Date*1000),(ulong)(TimeCurrent()*1000));
   int ot=FileOpen(Symbol()+"_Ticks.csv",FILE_WRITE|FILE_ANSI,",");
   string hdr="Date,Time,Bid,Ask,Last,Volume,Type";
   FileWrite(ot,hdr);
   int limit=ArraySize(t);
   for(int i=0;i<limit;i++)
   {
      string tt="0";
      if((t[i].flags&TICK_FLAG_BUY)==TICK_FLAG_BUY) tt="1";
      if((t[i].flags&TICK_FLAG_SELL)==TICK_FLAG_SELL) tt="-1";
      string d=TimeToString((ulong)(t[i].time),TIME_DATE)+","+TimeToString((ulong)(t[i].time),TIME_SECONDS)+","+DoubleToString(t[i].bid,Digits())+","+DoubleToString(t[i].ask,Digits())+","+DoubleToString(t[i].last,Digits())+","+IntegerToString(t[i].volume)+","+tt;
      FileWrite(ot,d);
   }
   FileClose(ot);
  }
//+------------------------------------------------------------------+
