"Sonar Station": Tech 1 Locates Water Units
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Sonar Station unit icon" src="icons/units/ARMSONAR_icon.png" />Sonar Station<br />Tech 1 Locates Water Units
            </th>
        </tr>
    </thead>
    <tbody>
        <tr><td align="center" colspan="2">Note: Several units have stats defined at the<br />start of the game based on the stats of others.</td></tr>
        <tr>
            <td align="right"><strong>Source:</strong></td>
            <td><a href="SCTATest">SCTATest</a></td>
        </tr>
        <tr>
            <td align="right"><strong>Unit ID:</strong></td>
            <td><code>armsonar</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Faction:</strong></td>
            <td>ARM</td>
        </tr>
        <tr>
            <td align="right"><strong>Tech level:</strong></td>
            <td><img src="icons/T1.png" title="Tech 1" /> 1</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Health:</strong></td>
            <td><img src="icons/health.png" title="Health" /> 50</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Structure</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 403</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 20</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>912 (<a href="#construction">Details</a>)</td>
        </tr>
        <tr>
            <td align="right"><strong>Maintenance cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 9/s</td>
        </tr>
        <tr>
            <td align="right"><strong>Energy production:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 9/s</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>12</td>
        </tr>
        <tr>
            <td align="right"><strong>Water vision radius:</strong></td>
            <td>12</td>
        </tr>
        <tr>
            <td align="right"><strong>Sonar radius:</strong></td>
            <td>74</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Weapons:</strong></td>
            <td>1 (<a href="#weapons">Details</a>)</td>
        </tr>
    </tbody>
</table>

"Sonar Station" is an ARM structure unit included in *SCTATest*.
It is classified as a tech 1 locates water units unit. It has no defined build description.<error:buildable unit with no build description>

<details>
<summary>Contents</summary>

1. – <a href="#abilities">Abilities</a>
2. – <a href="#construction">Construction</a>
3. – <a href="#order-capabilities">Order capabilities</a>
4. – <a href="#weapons">Weapons</a>
</details>

### Abilities
Hover over abilities to see effect descriptions.

* <span title="Can see blips of units not seen by vision that are on or below water">Sonar</span>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 00:07 ‒ <img src="icons/energy.png" title="Energy" /> 55/s ‒ <img src="icons/mass.png" title="Mass" /> 3/s — Built by <a href="ARMCS">Tech 1 Tech Level 1</a>
* <img src="icons/time.png" title="Time" /> 00:30 ‒ <img src="icons/energy.png" title="Energy" /> 13/s ‒ <img src="icons/mass.png" title="Mass" /> 1/s — Built by <a href="ARMDECOM">Tech 2 Commander</a>
* <img src="icons/time.png" title="Time" /> 00:11 ‒ <img src="icons/energy.png" title="Energy" /> 35/s ‒ <img src="icons/mass.png" title="Mass" /> 2/s — Built by <a href="ARMCH">Tech 3 Tech Level 3</a>
* <img src="icons/time.png" title="Time" /> 00:18 ‒ <img src="icons/energy.png" title="Energy" /> 22/s ‒ <img src="icons/mass.png" title="Mass" /> 1/s — Built by <a href="ARMCSA">Tech 3 Tech Level 3</a>
* <img src="icons/time.png" title="Time" /> 01:31 ‒ <img src="icons/energy.png" title="Energy" /> 4/s ‒ <img src="icons/mass.png" title="Mass" /> 0/s — Built by Armoured Command Unit
* <img src="icons/time.png" title="Time" /> 00:30 ‒ <img src="icons/energy.png" title="Energy" /> 13/s ‒ <img src="icons/mass.png" title="Mass" /> 1/s — Built by Tech 2 Armoured Command Unit
* <img src="icons/time.png" title="Time" /> 01:00 ‒ <img src="icons/energy.png" title="Energy" /> 7/s ‒ <img src="icons/mass.png" title="Mass" /> 0/s — Built by Tech 3 Engineer

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/stop.png" title="Stop" /></td>
<tr>
<td><img float="left" src="icons/orders/sonar.png" title="Sonar Toggle
Turn the selection units sonar on/off" /></td>
<td><img float="left" src="icons/orders/pause.png" title="Pause Construction
Pause/unpause current construction order" /></td>
</table>

### Weapons
<details>
<summary>DeathWeapon</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>50</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>5</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Damage friendly</td>
        </tr>
    </table>
</p>
</details>


<table align=center>
<td>Categories : <a href="_categories.ARM">ARM</a> · <a href="_categories.TECH1">TECH1</a> · <a href="_categories.NAVAL">NAVAL</a> · <a href="_categories.STRUCTURE">STRUCTURE</a>
