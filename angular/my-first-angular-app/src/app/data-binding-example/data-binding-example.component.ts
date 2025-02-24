import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-data-binding-example',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './data-binding-example.component.html',
  styleUrl: './data-binding-example.component.less'
})
export class DataBindingExample {
  status: string = 'pending';
  country = 'US';

  displayCountry() {
    console.log(this.country);
  }

}
 