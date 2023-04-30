import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';

import { MongooseModule } from '@nestjs/mongoose';
import { EventModule } from './event/event.module';
import { RouterModule } from '@nestjs/core';

@Module({
  imports: [
    MongooseModule.forRoot(
      'mongodb+srv://tiruzertsedeke26:WIG3KLEJER5H2Iy5@eventticketing.zqofp74.mongodb.net/EventTicketing?retryWrites=true&w=majority'
    ),
    EventModule,
    RouterModule.register([
      {path: 'event', module: EventModule}
    ])
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
