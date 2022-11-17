import React from 'react'

function Users(props) {
  return (
    <div>
      <h1>These users are from the API</h1>
      {props.users.map((user) => {
        return(
          <div key={user.id}>
            <h3>{user.email}</h3>
          </div>
        );
      })}
    </div>
  );
}

export default Users
