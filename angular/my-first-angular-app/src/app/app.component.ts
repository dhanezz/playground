import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';

// COMPONENTS IMPORTS
import { DataBindingExample } from './data-binding-example/data-binding-example.component';
import { LoginComponent } from './user-auth/login/login.component';

// NOTE: Common Module is imported to use the *ngIf directive

// NOTE: @Component class decorator is used to define the metadata for the component class. 
@Component({
  selector: 'app-root',
  imports: [RouterOutlet, CommonModule, DataBindingExample, LoginComponent], 
  standalone: true, // NOTE: standalone is set to true to so it doesn't require a parent component and can import other components directly
  templateUrl: './app.component.html',
  // template: `
  //   <h2>My First Angular App</h2>
  //   <p *ngIf="initialized">This text is visible if the condition is true.</p> 
  //   <p *ngIf="destroys">Component Destroyed</p>
  // `,
  styleUrl: './app.component.less'
})

export class AppComponent implements OnInit {
  title:string = 'my-first-angular-app';
  initialized: boolean = false;
  destroys: boolean = false;

  //@Input() data:string;
  //@Output() params:string;
  
  constructor() {
    console.log('AppComponent constructor called');
  }

  ngOnInit(): void {
    this.initialized = true;
    console.log('AppComponent ngOnInit called');
  }

  ngOnDestroy(): void {
    this.destroys = true;
    console.log('AppComponent ngOnDestroy called');
  }
}
